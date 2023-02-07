class HolidayResponse {
  final String status;
  final List<Holiday> holidays;

  HolidayResponse({
    required this.status,
    required this.holidays,
  });
}

class Holiday {
  final String id;
  final String holiday;
  final int dateEpoch;

  Holiday({
    required this.id,
    required this.holiday,
    required this.dateEpoch,
  });
}
