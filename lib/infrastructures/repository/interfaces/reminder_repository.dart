import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';

abstract class IReminderRepository {
  /// This function gets the scheduled reminders available to this current day.
  Future<APIListResponse<Reminder>> getScheduledReminder();

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the reminders available.
  Future<APIListResponse<Reminder>> getAllReminder();

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will create a reminder.
  ///
  /// [announcement] this defines the announcement text of the reminder.
  ///
  /// [startDate] determines when will this reminder starts to display.
  ///
  /// [endDate] determines when this reminder ends to display.
  ///
  /// [isShow] determines if the reminder is viewable by the user.
  Future<APIResponse<Reminder>> createReminder({
    required String announcement,
    required DateTime startDate,
    required DateTime endDate,
    required bool isShow,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will update a reminder.
  ///
  /// [announcement] this defines the announcment text of the reminder.
  ///
  /// [startDate] determines when will this reminder starts to display.
  ///
  /// [endDate] determines when will this reminder ends to display.
  ///
  /// [isShow] determines if the reminder is viewable by the user.
  Future<APIResponse<Reminder>> updateReminder({
    required String id,
    String? announcement,
    DateTime? startDate,
    DateTime? endDate,
    bool? isShow,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will delete a reminder.
  ///
  /// [id] determines which reminder to be deleted.
  Future<APIResponse<void>> deleteReminder({
    required String id,
  });
}
