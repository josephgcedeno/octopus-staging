import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/holiday_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HolidayRepository extends IHoliday {
  void checkFieldIsEmpty(String field) {
    if (field.isEmpty) {
      throw APIErrorResponse(
        message: 'ID or Holiday name cannot be empty!',
        errorCode: null,
      );
    }
  }

  @override
  Future<APIResponse<Holiday>> addHoliday({
    required String holidayName,
    required DateTime holidayDate,
  }) async {
    checkFieldIsEmpty(holidayName);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final HolidayParseObject holidays = HolidayParseObject();
        final int dateEpoch = epochFromDateTime(date: holidayDate);

        holidays
          ..name = holidayName
          ..date = dateEpoch;

        final ParseResponse addHolidayResponse = await holidays.save();

        if (addHolidayResponse.error != null) {
          formatAPIErrorResponse(error: addHolidayResponse.error!);
        }

        if (addHolidayResponse.success) {
          return APIResponse<Holiday>(
            success: true,
            message: 'Successfully added holiday.',
            data: Holiday(
              id: getResultId(addHolidayResponse.results!),
              dateEpoch: dateEpoch,
              holiday: holidayName,
            ),
            errorCode: null,
          );
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> deleteHoliday({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final HolidayParseObject holidays = HolidayParseObject();

        final ParseResponse holidayDeleteResponse =
            await holidays.delete(id: id);

        if (holidayDeleteResponse.error != null) {
          formatAPIErrorResponse(error: holidayDeleteResponse.error!);
        }

        if (holidayDeleteResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted holiday.',
            data: null,
            errorCode: null,
          );
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<Holiday>> getHoliday({
    String? holidayId,
    String? holidayName,
    DateTime? holidayDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final HolidayParseObject holidays = HolidayParseObject();
        final QueryBuilder<HolidayParseObject> holidayQuery =
            QueryBuilder<HolidayParseObject>(holidays);

        if (holidayName != null) {
          checkFieldIsEmpty(holidayName);
          holidayQuery.whereContains(HolidayParseObject.keyName, holidayName);
        }

        if (holidayDate != null) {
          holidayQuery.whereEqualTo(
            HolidayParseObject.keyDate,
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

        if (getHolidayResponse.error != null) {
          formatAPIErrorResponse(error: getHolidayResponse.error!);
        }

        if (getHolidayResponse.success) {
          final List<Holiday> holidays = <Holiday>[];

          if (getHolidayResponse.results != null) {
            for (final ParseObject result
                in getHolidayResponse.results! as List<ParseObject>) {
              final HolidayParseObject record =
                  HolidayParseObject.toCustomParseObject(data: result);

              holidays.add(
                Holiday(
                  id: record.objectId!,
                  holiday: record.name,
                  dateEpoch: record.date,
                ),
              );
            }
          }
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<Holiday>> updateHoliday({
    required String id,
    String? holidayName,
    DateTime? holidayDate,
  }) async {
    checkFieldIsEmpty(id);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final HolidayParseObject holidays = HolidayParseObject();
        holidays.objectId = id;

        if (holidayName != null) {
          checkFieldIsEmpty(holidayName);
          holidays.name = holidayName;
        }

        if (holidayDate != null) {
          holidays.date = epochFromDateTime(date: holidayDate);
        }

        final ParseResponse holidayUpdateResponse = await holidays.save();

        if (holidayUpdateResponse.error != null) {
          formatAPIErrorResponse(error: holidayUpdateResponse.error!);
        }

        if (holidayUpdateResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await holidays.getObject(id);

          if (getUpdatedRecordResponse.success &&
              getUpdatedRecordResponse.results != null) {
            final HolidayParseObject updatedRecord =
                HolidayParseObject.toCustomParseObject(
              data: getUpdatedRecordResponse.results!.first,
            );

            return APIResponse<Holiday>(
              success: true,
              message: 'Successfully updated holiday.',
              data: Holiday(
                id: updatedRecord.objectId!,
                holiday: updatedRecord.name,
                dateEpoch: updatedRecord.date,
              ),
              errorCode: null,
            );
          }
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }
}
