class AttendanceResponse {
  final String status;
  final List<Attendance> attendances;

  AttendanceResponse({
    required this.status,
    required this.attendances,
  });
}

class TimeInResponse {
  final String status;
  final TimeIn timeIn;

  TimeInResponse({
    required this.status,
    required this.timeIn,
  });
}

class TimeIn {
  final String id;
  final String holiday;
  final int dateEpoch;

  TimeIn({
    required this.id,
    required this.holiday,
    required this.dateEpoch,
  });
}

class Attendance {
  final String id;
  final int? timeInEpoch;
  final int? timeOutEpoch;
  final String timeInOutId;
  final String? offsetStatus;
  final int? offsetDuration;
  final int? requiredDuration;

  Attendance({
    required this.id,
    required this.timeInOutId,
    this.timeInEpoch,
    this.timeOutEpoch,
    this.offsetStatus,
    this.offsetDuration,
    this.requiredDuration,
  });
}
