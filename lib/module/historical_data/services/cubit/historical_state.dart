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
