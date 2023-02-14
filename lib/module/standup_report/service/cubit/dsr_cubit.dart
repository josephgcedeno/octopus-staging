import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';

part 'dsr_state.dart';

class DSRCubit extends Cubit<DSRState> {
  DSRCubit({required this.dsrRepository}) : super(const DSRState());

  final IDSRRepository dsrRepository;

  Future<void> fetchCurrentDate() async {
    try {
      emit(const FetchDatesLoading());

      final APIResponse<SprintRecord> response =
          await dsrRepository.sprintInfoQueryToday();

      final DateFormat dateFormat = DateFormat('MMM dd');

      final DateTime now = DateTime.now();
      final double days =
          (response.data.endDateEpoch - now.millisecondsSinceEpoch) / 86400000;

      final String startDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(response.data.startDateEpoch),
      );
      final String endDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(response.data.endDateEpoch),
      );

      final int remaining = 14 - days.ceil();
      emit(FetchDatesSuccess('$startDate - $endDate > Day $remaining of 14'));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchDatesFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  Future<void> initializeDSR() async {
    try {
      emit(const InitializeDSRLoading());

      final APIResponse<DSRRecord> response =
          await dsrRepository.initializeDSR();
      emit(
        InitializeDSRSuccess(
          doing: response.data.wip,
          done: response.data.done,
          blockers: response.data.blockers,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        InitializeDSRFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
