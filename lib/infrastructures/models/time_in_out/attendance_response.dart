/// This object will contain the necessary field for time in record.
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

/// This object will contain the necessary field for attendance record.
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
