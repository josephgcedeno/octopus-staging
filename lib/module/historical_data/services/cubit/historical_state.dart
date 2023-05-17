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

class FetchAttendancesReportLoading extends HistoricalState {
  FetchAttendancesReportLoading({
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);
}

class FetchAttendancesReportSucces extends HistoricalState {
  FetchAttendancesReportSucces({
    required this.employeeAttendances,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final List<EmployeeDailyTimeRecord> employeeAttendances;
}

class FetchAttendancesReportFailed extends HistoricalState {
  FetchAttendancesReportFailed({
    required this.errorCode,
    required this.message,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final String errorCode;
  final String message;
}

class FetchDSRReportLoading extends HistoricalState {
  FetchDSRReportLoading({
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);
}

class FetchDSRReportSuccess extends HistoricalState {
  FetchDSRReportSuccess({
    required this.userDsr,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final List<UserDSR> userDsr;
}

class FetchDSRReportFailed extends HistoricalState {
  FetchDSRReportFailed({
    required this.errorCode,
    required this.message,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final String errorCode;
  final String message;
}

class FetchLeaveReportLoading extends HistoricalState {
  FetchLeaveReportLoading({
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);
}

class FetchLeaveReportSuccess extends HistoricalState {
  FetchLeaveReportSuccess({
    required this.userLeaveRequests,
    required this.leaveType,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final List<UserLeaveRequest> userLeaveRequests;
  final String leaveType;
}

class FetchLeaveReportFailed extends HistoricalState {
  FetchLeaveReportFailed({
    required this.errorCode,
    required this.message,
    List<User>? selectedUser,
  }) : super(selectedUser: selectedUser);

  final String errorCode;
  final String message;
}
