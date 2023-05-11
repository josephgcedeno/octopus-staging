import 'dart:io';

import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/reminder_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ReminderRepository extends IReminderRepository {
  /// Only admin can create reminder.
  @override
  Future<APIResponse<Reminder>> createReminder({
    required String announcement,
    required DateTime startDate,
    required DateTime endDate,
    required bool isShow,
  }) async {
    if (announcement.isEmpty) {
      throw APIErrorResponse(
        message: 'Announcement field cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final PanelRemindersParseObject createReminder =
            PanelRemindersParseObject()
              ..announcement = announcement
              ..startDate = epochFromDateTime(date: startDate)
              ..endDate = epochFromDateTime(date: endDate)
              ..isShow = isShow;

        final ParseResponse createReminderReponse = await createReminder.save();

        if (createReminderReponse.error != null) {
          formatAPIErrorResponse(error: createReminderReponse.error!);
        }

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
  Future<APIListResponse<Reminder>> getAllReminder() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        final ParseResponse remindersResponse =
            await PanelRemindersParseObject().getAll();

        if (remindersResponse.error != null) {
          formatAPIErrorResponse(error: remindersResponse.error!);
        }

        if (remindersResponse.success) {
          final List<Reminder> reminders = <Reminder>[];

          if (remindersResponse.results != null) {
            for (final ParseObject result
                in remindersResponse.results! as List<ParseObject>) {
              final PanelRemindersParseObject record =
                  PanelRemindersParseObject.toCustomParseObject(data: result);

              reminders.add(
                Reminder(
                  id: record.objectId!,
                  announcement: record.announcement,
                  startDateEpoch: record.startDate,
                  endDateEpoch: record.endDate,
                  isShow: record.isShow,
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
      }

      throw APIErrorResponse(
        message: errorSomethingWentWrong,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<Reminder>> getScheduledReminder() async {
    try {
      final DateTime today = DateTime.now();

      final int fromDateTimeToEpoch = epochFromDateTime(date: today);

      /// Query every reminder that is in between with start date and end date.
      final QueryBuilder<PanelRemindersParseObject> requeryReminder =
          QueryBuilder<PanelRemindersParseObject>(PanelRemindersParseObject())
            ..whereLessThanOrEqualTo(
              PanelRemindersParseObject.keyStartDate,
              fromDateTimeToEpoch,
            )
            ..whereGreaterThanOrEqualsTo(
              PanelRemindersParseObject.keyEndDate,
              fromDateTimeToEpoch,
            )
            ..whereEqualTo(PanelRemindersParseObject.keyIsShow, true);

      final ParseResponse requeryReminderResponse =
          await requeryReminder.query();

      if (requeryReminderResponse.error != null) {
        formatAPIErrorResponse(error: requeryReminderResponse.error!);
      }

      final List<Reminder> reminders = <Reminder>[];

      if (requeryReminderResponse.results != null) {
        for (final ParseObject result
            in requeryReminderResponse.results! as List<ParseObject>) {
          final PanelRemindersParseObject record =
              PanelRemindersParseObject.toCustomParseObject(data: result);

          reminders.add(
            Reminder(
              id: record.objectId!,
              announcement: record.announcement,
              startDateEpoch: record.startDate,
              endDateEpoch: record.endDate,
              isShow: record.isShow,
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
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  /// Only admin can update reminder.
  @override
  Future<APIResponse<void>> deleteReminder({
    required String id,
  }) async {
    if (id.isEmpty) {
      throw APIErrorResponse(
        message: 'ID cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final PanelRemindersParseObject deleteReminder =
            PanelRemindersParseObject();

        final ParseResponse deleteReminderResponse =
            await deleteReminder.delete(id: id);

        if (deleteReminderResponse.error != null) {
          formatAPIErrorResponse(error: deleteReminderResponse.error!);
        }

        if (deleteReminderResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted reminder',
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

  /// Only admin can update reminder.
  @override
  Future<APIResponse<Reminder>> updateReminder({
    required String id,
    String? announcement,
    DateTime? startDate,
    DateTime? endDate,
    bool? isShow,
  }) async {
    if (id.isEmpty || (announcement != null && announcement.isEmpty)) {
      throw APIErrorResponse(
        message: 'This fields cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final PanelRemindersParseObject updateReminder =
            PanelRemindersParseObject();

        updateReminder.objectId = id;

        if (announcement != null) {
          updateReminder.announcement = announcement;
        }
        if (startDate != null) {
          updateReminder.startDate = epochFromDateTime(date: startDate);
        }
        if (endDate != null) {
          updateReminder.endDate = epochFromDateTime(date: endDate);
        }
        if (isShow != null) {
          updateReminder.isShow = isShow;
        }
        final ParseResponse updateReminderResponse =
            await updateReminder.save();

        if (updateReminderResponse.error != null) {
          formatAPIErrorResponse(error: updateReminderResponse.error!);
        }

        if (updateReminderResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(updateReminderResponse.results!);

          final ParseResponse reminderRecord =
              await updateReminder.getObject(objectId);
          if (reminderRecord.success && reminderRecord.results != null) {
            final PanelRemindersParseObject resultParseObject =
                PanelRemindersParseObject.toCustomParseObject(
              data: reminderRecord.results!.first,
            );

            return APIResponse<Reminder>(
              success: true,
              message: 'Successfully updated reminder.',
              data: Reminder(
                id: resultParseObject.objectId!,
                announcement: resultParseObject.announcement,
                startDateEpoch: resultParseObject.startDate,
                endDateEpoch: resultParseObject.endDate,
                isShow: resultParseObject.isShow,
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
