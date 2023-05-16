class EmployeeDailyTimeRecordDTO {
  EmployeeDailyTimeRecordDTO({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.attendances,
  });

  final String firstName;
  final String lastName;
  final String position;
  final List<DTRAttendance> attendances;
}

class DTRAttendance {
  DTRAttendance({
    required this.date,
    required this.timeInOut,
    required this.overTime,
  });

  final String date;
  final String timeInOut;
  final String overTime;
}
