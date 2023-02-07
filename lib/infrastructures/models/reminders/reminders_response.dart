class ReminderResponse {
  final String status;
  final List<Reminder> reminders;

  ReminderResponse({
    required this.status,
    required this.reminders,
  });
}

class Reminder {
  final String id;
  final String announcement;
  final int startDateEpoch;
  final int endDateEpoch;
  final bool isShow;

  Reminder({
    required this.id,
    required this.announcement,
    required this.startDateEpoch,
    required this.endDateEpoch,
    required this.isShow,
  });
}
