import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/reminder_repository.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({required this.reminderRepository}) : super(ReminderInitial());
  final IReminderRepository reminderRepository;

  Future<void> fetchReminderToday() async {
    try {
      emit(FetchReminderTodayLoading());

      final APIListResponse<Reminder> response =
          await reminderRepository.getScheduledReminder();

      emit(FetchReminderTodaySuccess(reminders: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchReminderTodayFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
