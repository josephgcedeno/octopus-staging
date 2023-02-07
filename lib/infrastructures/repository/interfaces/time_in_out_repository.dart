import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';

abstract class ITimeInOutRepository {
  /// This function gets the initial record whether if the use is already has an existing attendance for the day.
  Future<AttendanceResponse?> getInitialData();

  /// This function will sign in the user for the day.
  Future<AttendanceResponse> signInToday();

  /// This function will sign out the user fot the day.
  Future<AttendanceResponse> signOutToday();

  /// This function will request an offset to the admin.
  ///
  /// [hours] how many hours is the offset is.
  ///
  /// [minutes] how many minutes is the offset is.
  Future<AttendanceResponse> requestOffSet({
    required int hours,
    required int minutes,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the requesting user of the offset.
  ///
  /// [startDate] determines which date range to start fetching the request.
  ///
  /// [endDate] determines which date range to end fetching the request.
  Future<AttendanceResponse> getAllOffsetRequest({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will approved the offset request of the user.
  ///
  /// [attendanceId] which attendance record will be approved the offset.
  Future<AttendanceResponse> approveOffset({
    required String attendanceId,
  });

  /// This function will determines if the yesterdays offset if approved, get the extra MINUTES from yesterday's offset.
  Future<int> yesterdaysUsersOffSet();

  /// This function will simply update the time in out record if today is holiday.
  ///
  /// [id] which time in record does need to be updated.
  ///
  /// [holiday] determines what is the name of the holiday.
  Future<TimeInResponse> updateTimeInHoliday({
    required String id,
    required String holiday,
  });
}
