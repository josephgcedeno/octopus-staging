part of 'reminder_cubit.dart';

class ReminderState {
  const ReminderState();
}

class ReminderInitial extends ReminderState {}

class FetchReminderTodayLoading extends ReminderState {}

class FetchReminderTodaySuccess extends ReminderState {
  FetchReminderTodaySuccess({
    required this.reminders,
  });

  final List<Reminder> reminders;
}

class FetchReminderTodayFailed extends ReminderState {
  FetchReminderTodayFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
