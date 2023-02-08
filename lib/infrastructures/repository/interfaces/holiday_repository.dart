import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';

abstract class IHoliday {
  /// This function will get record/s of holiday/s.
  ///
  /// [holidayId] this identifies which record of holiday to get only.
  ///
  /// [holidayName] this search which holiday matches the query.
  ///
  /// [holidateDate] this get holiday that matches a certain date.
  Future<HolidayResponse> getHoliday({
    String? holidayId,
    String? holidayName,
    DateTime? holidateDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will create a holiday record.
  ///
  /// [holidayName] this identifies what is the holiday.
  ///
  /// [holidateDate] this identifies when is the holiday.
  Future<HolidayResponse> addHoliday({
    required String holidayName,
    required DateTime holidateDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will update a certain holiday record.
  ///
  /// [id] this identifies which holiday record will be updated.
  ///
  /// [holidayName] this identifies what is the holiday.
  Future<HolidayResponse> updateHoliday({
    required String id,
    String? holidayName,
    DateTime? holidateDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will delete a certain holiday record.
  ///
  /// [id] this identifies which holiday record will be deleted.
  Future<HolidayResponse> deleteHoliday({
    required String id,
  });
}
