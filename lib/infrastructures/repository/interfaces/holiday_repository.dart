import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';

abstract class IHoliday {
  /// This function will get record/s of holiday/s.
  ///
  /// [holidayId] this identifies which record of holiday to get only.
  ///
  /// [holidayName] this search which holiday matches the query.
  ///
  /// [holidayDate] this get holiday that matches a certain date.
  Future<APIListResponse<Holiday>> getHoliday({
    String? holidayId,
    String? holidayName,
    DateTime? holidayDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will create a holiday record.
  ///
  /// [holidayName] this identifies what is the holiday.
  ///
  /// [holidayDate] this identifies when is the holiday.
  Future<APIResponse<Holiday>> addHoliday({
    required String holidayName,
    required DateTime holidayDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will update a certain holiday record.
  ///
  /// [id] this identifies which holiday record will be updated.
  ///
  /// [holidayName] this identifies what is the holiday.
  Future<APIResponse<Holiday>> updateHoliday({
    required String id,
    String? holidayName,
    DateTime? holidayDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will delete a certain holiday record.
  ///
  /// [id] this identifies which holiday record will be deleted.
  Future<APIResponse<void>> deleteHoliday({
    required String id,
  });
}
