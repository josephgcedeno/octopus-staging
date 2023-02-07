import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';

abstract class IHoliday {
  Future<HolidayResponse> getHoliday({
    String? holidayId,
    String? holidayName,
    DateTime? holidateDate,
  });

  Future<HolidayResponse> addHoliday({
    required String holidayName,
    required DateTime holidateDate,
  });

  Future<HolidayResponse> updateHoliday({
    required String id,
    String? holidayName,
    DateTime? holidateDate,
  });

  Future<HolidayResponse> deleteHoliday({
    required String id,
  });
}
