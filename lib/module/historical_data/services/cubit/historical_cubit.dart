import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_dto.dart';

part 'historical_state.dart';

class HistoricalCubit extends Cubit<HistoricalState> {
  HistoricalCubit({
    required this.userRepository,
    required this.timeInOutRepository,
  }) : super(HistoricalInitial());

  final IUserRepository userRepository;
  final ITimeInOutRepository timeInOutRepository;

  Future<void> fetchAllUser() async {
    try {
      emit(FetchAllUserLoading());

      final APIListResponse<User> response = await userRepository.getAllUser();

      emit(FetchAllUserSuccess(users: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchAllUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  Future<void> fetchAllUserAttendancesReport({
    required List<User> users,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      emit(FetchAttendancesReportLoading());

      final List<EmployeeDailyTimeRecordDTO> employeeAttendances =
          <EmployeeDailyTimeRecordDTO>[];
      final APIListResponse<UserAttendance> response =
          await timeInOutRepository.fetchAttendances(
        users: users,
        today: today,
        from: from,
        to: to,
      );

      employeeAttendances.addAll(
        manageDTRAttendance(
          response.data,
          users,
          today: today,
          from: from,
          to: to,
        ),
      );

      emit(
        FetchAttendancesReportSucces(
          employeeAttendances: employeeAttendances,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchAttendancesReportFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  void toggleUser(User user) {
    if (state.selectedUser?.contains(user) ?? false) {
      emit(
        HistoricalState(
          selectedUser: List<User>.of(state.selectedUser ?? <User>[])
            ..remove(user),
        ),
      );
    } else {
      emit(
        HistoricalState(
          selectedUser: List<User>.of(state.selectedUser ?? <User>[])
            ..add(user),
        ),
      );
    }
  }

  List<EmployeeDailyTimeRecordDTO> manageDTRAttendance(
    List<UserAttendance> data,
    List<User> users, {
    DateTime? to,
    DateTime? from,
    DateTime? today,
  }) {
    final List<EmployeeDailyTimeRecordDTO> employeeAttendances =
        <EmployeeDailyTimeRecordDTO>[];

    for (final UserAttendance userAttendance in data) {
      final User userObject = users.firstWhere(
        (User element) => element.userId == userAttendance.userId,
      );
      final List<DTRAttendance> dtrAtttendance = <DTRAttendance>[];

      if (today != null) {
        for (final Attendance userAttendance in userAttendance.attendances) {
          final String date = DateFormat('MMM dd, yyyy').format(today);

          final String timeIn = userAttendance.timeInEpoch != null
              ? DateFormat('h:mm a').format(
                  dateTimeFromEpoch(
                    epoch: userAttendance.timeInEpoch ?? 0,
                  ),
                )
              : '--';

          final String timeOut = userAttendance.timeOutEpoch != null
              ? DateFormat('h:mm a').format(
                  dateTimeFromEpoch(
                    epoch: userAttendance.timeOutEpoch ?? 0,
                  ),
                )
              : '--';

          dtrAtttendance.add(
            DTRAttendance(
              date: date,
              overTime: userAttendance.timeInEpoch != null &&
                      userAttendance.timeOutEpoch != null
                  ? computeOverTime(
                      timeInEpoch: userAttendance.timeInEpoch!,
                      timeOutEpoch: userAttendance.timeOutEpoch!,
                    )
                  : '---',
              timeInOut: '$timeIn - $timeOut',
            ),
          );
        }
      } else if (from != null && to != null) {
        final Duration dateRange = to.difference(from);

        for (int i = 0; i < dateRange.inDays + 1; i++) {
          const String emptyResult = '-1';
          final DateTime dateNow = DateTime(
            from.year,
            from.month,
            from.day,
          ).add(Duration(days: i));

          /// Check if the generated date
          final Attendance matchingRecordWithDate =
              userAttendance.attendances.firstWhere(
            (Attendance? element) =>
                element?.date == epochFromDateTime(date: dateNow),
            orElse: () => Attendance(
              id: emptyResult,
              timeInOutId: '',
            ),
          );
          final String date = DateFormat('MMM dd, yyyy').format(dateNow);
          String timeInOut = '---';
          String overTime = '---';
          if (matchingRecordWithDate.id != emptyResult) {
            final String timeIn = matchingRecordWithDate.timeInEpoch != null
                ? DateFormat('h:mm a').format(
                    dateTimeFromEpoch(
                      epoch: matchingRecordWithDate.timeInEpoch ?? 0,
                    ),
                  )
                : '--';

            final String timeOut = matchingRecordWithDate.timeOutEpoch != null
                ? DateFormat('h:mm a').format(
                    dateTimeFromEpoch(
                      epoch: matchingRecordWithDate.timeOutEpoch ?? 0,
                    ),
                  )
                : '--';

            if (matchingRecordWithDate.timeInEpoch != null &&
                matchingRecordWithDate.timeOutEpoch != null) {
              overTime = computeOverTime(
                timeInEpoch: matchingRecordWithDate.timeInEpoch!,
                timeOutEpoch: matchingRecordWithDate.timeOutEpoch!,
              );
            }

            timeInOut = '$timeIn - $timeOut';
          }

          dtrAtttendance.add(
            DTRAttendance(
              date: date,
              overTime: overTime,
              timeInOut: timeInOut,
            ),
          );
        }
      }

      employeeAttendances.add(
        EmployeeDailyTimeRecordDTO(
          attendances: dtrAtttendance,
          firstName: userObject.firstName,
          lastName: userObject.lastName,
          position: userObject.position,
        ),
      );
    }
    return employeeAttendances;
  }
}
