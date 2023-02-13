/// This object will contain the necessary field for Holiday record.
class Holiday {
  Holiday({
    required this.id,
    required this.holiday,
    required this.dateEpoch,
  });

  final String id;
  final String holiday;
  final int dateEpoch;
}
