class AttendanceResponse {
  AttendanceResponse({
    required this.status,
    required this.attendances,
  });

  final String status;
  final List<Attendance> attendances;
}

class TimeInResponse {
  TimeInResponse({
    required this.status,
    required this.timeIn,
  });

  final String status;
  final TimeIn timeIn;
}

class TimeIn {
  TimeIn({
    required this.id,
    required this.holiday,
    required this.dateEpoch,
  });

  final String id;
  final String holiday;
  final int dateEpoch;
}

class Attendance {
  Attendance({
    required this.id,
    required this.timeInOutId,
    this.timeInEpoch,
    this.timeOutEpoch,
    this.offsetStatus,
    this.offsetDuration,
    this.requiredDuration,
  });
  final String id;
  final int? timeInEpoch;
  final int? timeOutEpoch;
  final String timeInOutId;
  final String? offsetStatus;
  final int? offsetDuration;
  final int? requiredDuration;
}
