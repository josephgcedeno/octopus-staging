import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/holiday/holiday_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/holiday_repository.dart';
import 'package:octopus/internal/database_strings.dart';
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
        final ParseObject holidays = ParseObject(holidaysTable);
        final int dateEpoch = epochFromDateTime(date: holidayDate);

        holidays
          ..set(holidayNameField, holidayName)
          ..set<int>(holidayDateField, dateEpoch);

        final ParseResponse addHolidayResponse = await holidays.save();

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
        throw APIErrorResponse(
          message: addHolidayResponse.error != null
              ? addHolidayResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
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
        final ParseObject holidays = ParseObject(holidaysTable);

        final ParseResponse holidayDeleteResponse =
            await holidays.delete(id: id);

        if (holidayDeleteResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted holiday.',
            data: null,
            errorCode: null,
          );
        }
        throw APIErrorResponse(
          message: holidayDeleteResponse.error != null
              ? holidayDeleteResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
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
        final ParseObject holidays = ParseObject(holidaysTable);
        final QueryBuilder<ParseObject> holidayQuery =
            QueryBuilder<ParseObject>(holidays);

        if (holidayName != null) {
          checkFieldIsEmpty(holidayName);
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
          return APIListResponse<Holiday>(
            success: true,
            message: 'Successfully get holidays',
            data: holidays,
            errorCode: null,
          );
        }
        throw APIErrorResponse(
          message: getHolidayResponse.error != null
              ? getHolidayResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
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
        final ParseObject holidays = ParseObject(holidaysTable);
        holidays.objectId = id;

        if (holidayName != null) {
          checkFieldIsEmpty(holidayName);
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

            return APIResponse<Holiday>(
              success: true,
              message: 'Successfully updated holiday.',
              data: Holiday(
                id: updatedRecord.objectId!,
                holiday: updatedRecord.get<String>(holidayNameField)!,
                dateEpoch: updatedRecord.get<int>(holidayDateField)!,
              ),
              errorCode: null,
            );
          }
        }
        throw APIErrorResponse(
          message: holidayUpdateResponse.error != null
              ? holidayUpdateResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }
}
