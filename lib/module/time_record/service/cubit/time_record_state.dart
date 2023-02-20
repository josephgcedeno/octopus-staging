part of 'time_record_cubit.dart';

class TimeRecordState {
  const TimeRecordState();
}

/// Event Classes
class FetchTimeInDataLoading extends TimeRecordState {
  FetchTimeInDataLoading() : super();
}

class FetchTimeInDataSuccess extends TimeRecordState {
  const FetchTimeInDataSuccess({
    required this.attendance,
  }) : super();

  final Attendance? attendance;
}

class FetchTimeInDataFailed extends TimeRecordState {
  const FetchTimeInDataFailed({
    required this.errorCode,
    required this.message,
  }) : super();

  final String errorCode;
  final String message;
}
