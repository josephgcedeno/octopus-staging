import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/quote/quote_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';

part 'time_record_state.dart';

/// Cubit for general Quote
class TimeRecordCubit extends Cubit<TimeRecordState> {
  TimeRecordCubit({required this.timeInOutRepository})
      : super(const TimeRecordState());

  final ITimeInOutRepository timeInOutRepository;

  /// Get initial data.
  Future<void> fetchAttendance() async {
    try {
      emit(FetchTimeInDataLoading());

      final AttendanceResponse? isAlreadyIn =
          await timeInOutRepository.getInitialData();

      if (isAlreadyIn != null) {
        emit(
          FetchTimeInDataLoadingSuccess(
            attendance: isAlreadyIn.attendances.first,
          ),
        );
      }
    } catch (e) {
      final APIResponse<void> error = e as APIResponse<void>;
      emit(
        FetchTimeInDataLoadingFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    }
  }

  /// Time in today
  Future<void> signInToday() async {
    try {
      emit(FetchTimeInDataLoading());

      final AttendanceResponse signInToday =
          await timeInOutRepository.signInToday();

      if (signInToday.status == 'success') {
        emit(
          FetchTimeInDataLoadingSuccess(
            attendance: signInToday.attendances.first,
          ),
        );
      }
    } catch (e) {
      final APIResponse<void> error = e as APIResponse<void>;
      emit(
        FetchTimeInDataLoadingFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    }
  }
}
