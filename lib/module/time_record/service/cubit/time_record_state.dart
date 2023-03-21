part of 'time_record_cubit.dart';

enum ExecutedOrigin { requestOffset, fetchAttendance, signIn, signOut }

class TimeRecordState {
  TimeRecordState({this.origin});

  ExecutedOrigin? origin;
}

/// Event Classes
class FetchTimeInDataLoading extends TimeRecordState {
  FetchTimeInDataLoading({
    required ExecutedOrigin origin,
  }) : super(origin: origin);
}

class FetchTimeInDataSuccess extends TimeRecordState {
  FetchTimeInDataSuccess({
    required this.attendance,
    required ExecutedOrigin origin,
  }) : super(origin: origin);

  final Attendance? attendance;
}

class FetchTimeInDataFailed extends TimeRecordState {
  FetchTimeInDataFailed({
    required this.errorCode,
    required this.message,
    required ExecutedOrigin origin,
  }) : super(origin: origin);

  final String errorCode;
  final String message;
}
