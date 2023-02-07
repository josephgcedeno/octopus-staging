import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';

abstract class IReminderRepository {
  /// This function gets the scheduled reminders available to this current day.
  Future<ReminderResponse> getScheduledReminder();

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the reminder available.
  Future<ReminderResponse> getAllReminder();

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will create a reminder.
  ///
  /// [announcement] this defines the announcment text of the reminder.
  ///
  /// [startDate] determines when will this reminder starts to display.
  ///
  /// [endDate] determines when will this reminder ends to display.
  ///
  /// [isShow] determines if the reminder is viewable by the user.
  Future<ReminderResponse> createReminder({
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
  Future<ReminderResponse> updateReminder({
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
  Future<ReminderResponse> deleteReminder({
    required String id,
  });
}
