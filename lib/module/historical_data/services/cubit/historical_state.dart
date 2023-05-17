part of 'historical_cubit.dart';

class HistoricalState {
  const HistoricalState({
    this.selectedUser,
  });

  final List<User>? selectedUser;
}

class HistoricalInitial extends HistoricalState {}

class FetchAllUserLoading extends HistoricalState {}

class FetchAllUserSuccess extends HistoricalState {
  FetchAllUserSuccess({required this.users});

  final List<User> users;
}

class FetchAllUserFailed extends HistoricalState {
  FetchAllUserFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchAttendancesReportLoading extends HistoricalState {}

class FetchAttendancesReportSucces extends HistoricalState {
  FetchAttendancesReportSucces({
    required this.employeeAttendances,
  });

  final List<EmployeeDailyTimeRecordDTO> employeeAttendances;
}

class FetchAttendancesReportFailed extends HistoricalState {
  FetchAttendancesReportFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchDSRReportLoading extends HistoricalState {}

class FetchDSRReportSuccess extends HistoricalState {
  FetchDSRReportSuccess({
    required this.userDsr,
  });

  final List<UserDSR> userDsr;
}

class FetchDSRReportFailed extends HistoricalState {
  FetchDSRReportFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchLeaveReportLoading extends HistoricalState {}

class FetchLeaveReportSuccess extends HistoricalState {
  FetchLeaveReportSuccess({
    required this.userLeaveRequests,
  });

  final List<UserLeaveRequest> userLeaveRequests;
}

class FetchLeaveReportFailed extends HistoricalState {
  FetchLeaveReportFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
