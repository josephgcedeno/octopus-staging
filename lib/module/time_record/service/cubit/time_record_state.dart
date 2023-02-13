part of 'time_record_cubit.dart';

class TimeRecordState {
  const TimeRecordState();
}

/// Event Classes
class FetchTimeInDataLoading extends TimeRecordState {
  FetchTimeInDataLoading() : super();
}

class FetchTimeInDataLoadingSuccess extends TimeRecordState {
  const FetchTimeInDataLoadingSuccess({
    required this.attendance,
  }) : super();

  final Attendance attendance;
}

class FetchTimeInDataLoadingFailed extends TimeRecordState {
  const FetchTimeInDataLoadingFailed({
    required this.errorCode,
    required this.message,
  }) : super();

  final String errorCode;
  final String message;
}
