/// This object will contain the necessary field for reminder record.
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
