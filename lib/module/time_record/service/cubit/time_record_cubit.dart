import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';

part 'time_record_state.dart';

/// Cubit for general Quote
class TimeRecordCubit extends Cubit<TimeRecordState> {
  TimeRecordCubit({required this.timeInOutRepository})
      : super(TimeRecordState());

  final ITimeInOutRepository timeInOutRepository;

  /// Get initial data.
  Future<void> fetchAttendance() async {
    try {
      emit(FetchTimeInDataLoading());
      final APIResponse<Attendance?> isAlreadyIn =
          await timeInOutRepository.getInitialData();

      /// This will emit either attendance with attendance success with attendance data or there is no attendance yet emit success but with null.
      emit(
        FetchTimeInDataSuccess(
          attendance: isAlreadyIn.data,
          origin: ExecutedOrigin.fetchAttendance,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchTimeInDataFailed(
          errorCode: error.errorCode!,
          message: error.message,
          origin: ExecutedOrigin.fetchAttendance,
        ),
      );
    }
  }

  /// Time in today
  Future<void> signInToday() async {
    try {
      emit(FetchTimeInDataLoading());

      final APIResponse<Attendance> signInToday =
          await timeInOutRepository.signInToday();

      emit(
        FetchTimeInDataSuccess(
          attendance: signInToday.data,
          origin: ExecutedOrigin.signIn,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchTimeInDataFailed(
          errorCode: error.errorCode!,
          message: error.message,
          origin: ExecutedOrigin.signIn,
        ),
      );
    }
  }

  /// Time out today
  Future<void> signOutToday() async {
    try {
      emit(FetchTimeInDataLoading());

      final APIResponse<Attendance> signOutToday =
          await timeInOutRepository.signOutToday();

      emit(
        FetchTimeInDataSuccess(
          attendance: signOutToday.data,
          origin: ExecutedOrigin.signOut,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchTimeInDataFailed(
          errorCode: error.errorCode!,
          message: error.message,
          origin: ExecutedOrigin.signOut,
        ),
      );
    }
  }

  Future<void> requestOffset({
    required Duration offsetDuration,
    required String fromTime,
    required String toTime,
    required String reason,
  }) async {
    try {
      emit(FetchTimeInDataLoading());

      final APIResponse<Attendance> requestOffset =
          await timeInOutRepository.requestOffSet(
        fromTime: fromTime,
        offsetDuration: offsetDuration,
        reason: reason,
        toTime: toTime,
      );

      emit(
        FetchTimeInDataSuccess(
          attendance: requestOffset.data,
          origin: ExecutedOrigin.requestOffset,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchTimeInDataFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
          origin: ExecutedOrigin.requestOffset,
        ),
      );
    }
  }
}
