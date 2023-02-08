class HolidayResponse {
  HolidayResponse({
    required this.status,
    required this.holidays,
  });

  final String status;
  final List<Holiday> holidays;
}

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
