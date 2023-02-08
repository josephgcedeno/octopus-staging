class ReminderResponse {
  ReminderResponse({
    required this.status,
    required this.reminders,
  });

  final String status;
  final List<Reminder> reminders;
}

class Reminder {
  Reminder({
    required this.id,
    required this.announcement,
    required this.startDateEpoch,
    required this.endDateEpoch,
    required this.isShow,
  });

  final String id;
  final String announcement;
  final int startDateEpoch;
  final int endDateEpoch;
  final bool isShow;
}
