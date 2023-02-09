import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/holiday_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HolidayRepository extends IHoliday {
  @override
  Future<HolidayResponse> addHoliday({
    required String holidayName,
    required DateTime holidayDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject holidays = ParseObject(holidaysTable);
      final int dateEpoch = epochFromDateTime(date: holidayDate);

      holidays
        ..set(holidayNameField, holidayName)
        ..set<int>(holidayDateField, dateEpoch);

      final ParseResponse addHolidayResponse = await holidays.save();

      if (addHolidayResponse.success) {
        return HolidayResponse(
          holidays: <Holiday>[
            Holiday(
              id: getResultId(addHolidayResponse.results!),
              dateEpoch: dateEpoch,
              holiday: holidayName,
            )
          ],
          status: 'success',
        );
      }
      throw APIResponse<void>(
        success: false,
        message: addHolidayResponse.error != null
            ? addHolidayResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<HolidayResponse> deleteHoliday({required String id}) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject holidays = ParseObject(holidaysTable);

      final ParseResponse holidayDeleteResponse = await holidays.delete(id: id);

      if (holidayDeleteResponse.success) {
        return HolidayResponse(
          holidays: <Holiday>[],
          status: 'success',
        );
      }
      throw APIResponse<void>(
        success: false,
        message: holidayDeleteResponse.error != null
            ? holidayDeleteResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<HolidayResponse> getHoliday({
    String? holidayId,
    String? holidayName,
    DateTime? holidayDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject holidays = ParseObject(holidaysTable);
      final QueryBuilder<ParseObject> holidayQuery =
          QueryBuilder<ParseObject>(holidays);

      if (holidayName != null) {
        holidayQuery.whereContains(holidayNameField, holidayName);
      }

      if (holidayDate != null) {
        holidayQuery.whereEqualTo(
          holidayDateField,
          epochFromDateTime(
            date: holidayDate,
          ),
        );
      }

      final ParseResponse getHolidayResponse =
          holidayDate != null || holidayName != null
              ? await holidayQuery.query()
              : holidayId != null
                  ? await holidays.getObject(holidayId)
                  : await holidays.getAll();

      if (getHolidayResponse.success) {
        final List<Holiday> holidays = <Holiday>[];

        if (getHolidayResponse.results != null) {
          for (final ParseObject result
              in getHolidayResponse.results! as List<ParseObject>) {
            holidays.add(
              Holiday(
                id: result.objectId!,
                holiday: result.get<String>(holidayNameField)!,
                dateEpoch: result.get<int>(holidayDateField)!,
              ),
            );
          }
        }
        return HolidayResponse(
          holidays: holidays,
          status: '',
        );
      }
      throw APIResponse<void>(
        success: false,
        message: getHolidayResponse.error != null
            ? getHolidayResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<HolidayResponse> updateHoliday({
    required String id,
    String? holidayName,
    DateTime? holidayDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject holidays = ParseObject(holidaysTable);
      holidays.objectId = id;

      if (holidayName != null) {
        holidays.set<String>(holidayNameField, holidayName);
      }

      if (holidayDate != null) {
        holidays.set<int>(
          holidayDateField,
          epochFromDateTime(
            date: holidayDate,
          ),
        );
      }
      final ParseResponse holidayUpdateResponse = await holidays.save();

      if (holidayUpdateResponse.success) {
        final ParseResponse getUpdatedRecordResponse =
            await holidays.getObject(id);

        if (getUpdatedRecordResponse.success &&
            getUpdatedRecordResponse.results != null) {
          final ParseObject updatedRecord =
              getParseObject(getUpdatedRecordResponse.results!);

          return HolidayResponse(
            holidays: <Holiday>[
              Holiday(
                id: updatedRecord.objectId!,
                holiday: updatedRecord.get<String>(holidayNameField)!,
                dateEpoch: updatedRecord.get<int>(holidayDateField)!,
              ),
            ],
            status: 'success',
          );
        }
      }
      throw APIResponse<void>(
        success: false,
        message: holidayUpdateResponse.error != null
            ? holidayUpdateResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }
}
