import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

abstract class ITimeInOutRepository {
  /// This function gets the initial record whether the use is already has an existing attendance for the day.
  Future<APIResponse<Attendance?>> getInitialData();

  /// This function will sign in the user for the day.
  Future<APIResponse<Attendance>> signInToday();

  /// This function will sign out the user for the day.
  Future<APIResponse<Attendance>> signOutToday();

  /// This function will request an offset to the admin.
  ///
  /// [offsetDuration] the duration of the requested offset.
  ///
  /// [fromTime] from what time the user would like to offset. Eg 3:20 PM
  ///
  /// [toTime] to what time the user would like to offset. Eg 4:20 PM
  ///
  /// [reason] the reason why would the user wants to request offset
  Future<APIResponse<Attendance>> requestOffSet({
    required Duration offsetDuration,
    required String fromTime,
    required String toTime,
    required String reason,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the requesting user of the offset.
  ///
  /// [startDate] determines which date range to start fetching the request.
  ///
  /// [endDate] determines which date range to end fetching the request.
  Future<APIListResponse<Attendance>> getAllOffsetRequest({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will approve the offset request of the user.
  ///
  /// [attendanceId] which attendance record will be approved the offset.
  Future<APIResponse<Attendance>> approveOffset({
    required String attendanceId,
  });

  /// This function will determines if the yesterdays offset if approved, get the extra MINUTES from yesterday's offset.
  Future<APIResponse<int>> yesterdaysUsersOffSet();

  /// This function will simply update the time in out record if today is holiday.
  ///
  /// [id] which time in record does need to be updated.
  ///
  /// [holiday] determines what is the name of the holiday.
  Future<APIResponse<TimeIn>> updateTimeInHoliday({
    required String id,
    required String holidayId,
  });

  /// Fetches attendance records from the server for the specified users and time range.
  ///
  /// [users] A list of [User] objects representing the users for which attendance records are to be fetched.
  ///
  /// [today] representing the current date. If provided, only attendance records
  ///
  /// [from] representing the start of the time range. If provided, only attendance records from this date and onwards will be fetched.
  ///
  /// [to] representing the end of the time range. If provided, only attendance records up to this date will be fetched.
  Future<APIListResponse<UserAttendance>> fetchAttendances({
    required List<User> users,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  });
}
