import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/reminder_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ReminderRepository extends IReminderRepository {
  /// Only admin can create reminder.
  @override
  Future<APIResponse<Reminder>> createReminder({
    required String announcement,
    required DateTime startDate,
    required DateTime endDate,
    required bool isShow,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject createReminder = ParseObject(panelRemindersTable)
          ..set<String>(pannelRemindersAnnouncementField, announcement)
          ..set<int>(
            pannelRemindersStartDateField,
            epochFromDateTime(date: startDate),
          )
          ..set<int>(
            pannelRemindersEndDateField,
            epochFromDateTime(date: endDate),
          )
          ..set<bool>(pannelRemindersIsShowField, isShow);

        final ParseResponse createReminderReponse = await createReminder.save();

        if (createReminderReponse.success &&
            createReminderReponse.results != null) {
          return APIResponse<Reminder>(
            success: true,
            message: 'Successfully created reminder',
            data: Reminder(
              id: getResultId(createReminderReponse.results!),
              announcement: announcement,
              endDateEpoch: epochFromDateTime(date: endDate),
              isShow: isShow,
              startDateEpoch: epochFromDateTime(date: startDate),
            ),
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: createReminderReponse.error != null
              ? createReminderReponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  /// Only admin can access all reminders.
  @override
  Future<APIListResponse<Reminder>> getAllReminder() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseResponse remindersResponse =
            await ParseObject(panelRemindersTable).getAll();

        if (remindersResponse.success) {
          final List<Reminder> reminders = <Reminder>[];

          if (remindersResponse.results != null) {
            for (final ParseObject result
                in remindersResponse.results! as List<ParseObject>) {
              reminders.add(
                Reminder(
                  id: result.objectId!,
                  announcement:
                      result.get<String>(pannelRemindersAnnouncementField)!,
                  startDateEpoch:
                      result.get<int>(pannelRemindersStartDateField)!,
                  endDateEpoch: result.get<int>(pannelRemindersEndDateField)!,
                  isShow: result.get<bool>(pannelRemindersIsShowField)!,
                ),
              );
            }
          }

          return APIListResponse<Reminder>(
            success: true,
            message: 'Successfully get all reminders',
            data: reminders,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: remindersResponse.error != null
              ? remindersResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<Reminder>> getScheduledReminder() async {
    try {
      final DateTime today = DateTime.now();

      final int fromDateTimeToEpoch = epochFromDateTime(date: today);

      /// Query every reminder that is in between with start date and end date.
      final QueryBuilder<ParseObject> requeryReminder =
          QueryBuilder<ParseObject>(ParseObject(panelRemindersTable))
            ..whereLessThanOrEqualTo(
              pannelRemindersStartDateField,
              fromDateTimeToEpoch,
            )
            ..whereGreaterThanOrEqualsTo(
              pannelRemindersEndDateField,
              fromDateTimeToEpoch,
            )
            ..whereEqualTo(pannelRemindersIsShowField, true);

      final ParseResponse requeryReminderResponse =
          await requeryReminder.query();

      if (requeryReminderResponse.success) {
        final List<Reminder> reminders = <Reminder>[];

        if (requeryReminderResponse.results != null) {
          for (final ParseObject result
              in requeryReminderResponse.results! as List<ParseObject>) {
            reminders.add(
              Reminder(
                id: result.objectId!,
                announcement:
                    result.get<String>(pannelRemindersAnnouncementField)!,
                startDateEpoch: result.get<int>(pannelRemindersStartDateField)!,
                endDateEpoch: result.get<int>(pannelRemindersEndDateField)!,
                isShow: result.get<bool>(pannelRemindersIsShowField)!,
              ),
            );
          }
        }
        return APIListResponse<Reminder>(
          success: true,
          message: 'Successfully get all scheduled reminder',
          data: reminders,
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: requeryReminderResponse.error != null
            ? requeryReminderResponse.error!.message
            : '',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  /// Only admin can update reminder.
  @override
  Future<APIResponse<void>> deleteReminder({
    required String id,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject deleteReminder = ParseObject(panelRemindersTable);

        final ParseResponse deleteReminderResponse =
            await deleteReminder.delete(id: id);

        if (deleteReminderResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted reminder',
            data: null,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: deleteReminderResponse.error != null
              ? deleteReminderResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  /// Only admin can update reminder.
  @override
  Future<APIResponse<Reminder>> updateReminder({
    required String id,
    String? announcement,
    DateTime? startDate,
    DateTime? endDate,
    bool? isShow,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject updateReminder = ParseObject(panelRemindersTable);

        updateReminder.objectId = id;

        if (announcement != null) {
          updateReminder.set<String>(
            pannelRemindersAnnouncementField,
            announcement,
          );
        }
        if (startDate != null) {
          updateReminder.set<int>(
            pannelRemindersStartDateField,
            epochFromDateTime(date: startDate),
          );
        }
        if (endDate != null) {
          updateReminder.set<int>(
            pannelRemindersEndDateField,
            epochFromDateTime(date: endDate),
          );
        }
        if (isShow != null) {
          updateReminder.set<bool>(pannelRemindersIsShowField, isShow);
        }
        final ParseResponse updateReminderResponse =
            await updateReminder.save();

        if (updateReminderResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(updateReminderResponse.results!);

          final ParseResponse reminderRecord =
              await updateReminder.getObject(objectId);
          if (reminderRecord.success && reminderRecord.results != null) {
            final ParseObject resultParseObject =
                getParseObject(reminderRecord.results!);

            return APIResponse<Reminder>(
              success: true,
              message: 'Successfully updated reminder.',
              data: Reminder(
                id: resultParseObject.objectId!,
                announcement: resultParseObject
                    .get<String>(pannelRemindersAnnouncementField)!,
                startDateEpoch:
                    resultParseObject.get<int>(pannelRemindersStartDateField)!,
                endDateEpoch:
                    resultParseObject.get<int>(pannelRemindersEndDateField)!,
                isShow:
                    resultParseObject.get<bool>(pannelRemindersIsShowField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateReminderResponse.error != null
              ? updateReminderResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }
}
