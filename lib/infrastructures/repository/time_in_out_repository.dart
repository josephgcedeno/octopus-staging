import 'dart:io';

import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class TimeInOutRepository extends ITimeInOutRepository {
  final DateTime _now = DateTime.now();

  DateTime get _currentDate => DateTime(_now.year, _now.month, _now.day);

  /// This function will check if today is holiday, if it is holiday, return the parse object for the record for this holiday such as ID.
  Future<ParseObject?> todayHoliday(
    DateTime today,
  ) async {
    final ParseObject holiday = ParseObject(holidaysTable);
    final QueryBuilder<ParseObject> holidayTodayQuery =
        QueryBuilder<ParseObject>(holiday)
          ..whereEqualTo(
            holidayDateField,
            epochFromDateTime(date: today),
          );
    final ParseResponse holidayTodayQueryResponse =
        await holidayTodayQuery.query();

    if (holidayTodayQueryResponse.success) {
      if (holidayTodayQueryResponse.results != null) {
        return getParseObject(holidayTodayQueryResponse.results!);
      }
    }

    return null;
  }

  Future<void> createNewDate() async {
    final DateTime date = DateTime(_now.year, _now.month, _now.day);

    final ParseObject timeInOut = ParseObject(timeInOutsTable);
    final QueryBuilder<ParseObject> isTodayPresent = QueryBuilder<ParseObject>(
      timeInOut,
    )
      ..whereGreaterThanOrEqualsTo(
        timeInOutDateField,
        epochFromDateTime(date: date),
      )
      ..whereLessThan(
        timeInOutDateField,
        epochFromDateTime(date: DateTime(_now.year, _now.month, _now.day + 1)),
      );

    final ParseResponse responseDsr = await isTodayPresent.query();

    /// If empty create one.
    if (responseDsr.count == 0) {
      /// Check if today is holiday base from the holiday table.
      final ParseObject? holidayToday = await todayHoliday(date);

      final ParseObject timeINOUt = timeInOut
        ..set<String>(timeInOutsHolidayIdField, holidayToday?.objectId ?? '')
        ..set<int>(timeInOutDateField, epochFromDateTime(date: date));

      await timeINOUt.save();
    }
  }

  /// Get record only from yesterday or today. If today is set to false. Get the record from yesterday. If today is true. Get the record for today.
  Future<ParseObject?> dateRecordInfo({
    bool today = true,
  }) async {
    final QueryBuilder<ParseObject> todayRecord =
        QueryBuilder<ParseObject>(ParseObject(timeInOutsTable))
          ..whereGreaterThanOrEqualsTo(
            timeInOutDateField,
            today
                ? epochFromDateTime(
                    date: _currentDate,
                  )
                : epochFromDateTime(
                    date: DateTime(_now.year, _now.month, _now.day - 1),
                  ),
          )
          ..whereLessThan(
            timeInOutDateField,
            today
                ? epochFromDateTime(
                    date: DateTime(_now.year, _now.month, _now.day + 1),
                  )
                : epochFromDateTime(
                    date: _currentDate,
                  ),
          );
    final ParseResponse queryTodayRecrod = await todayRecord.query();
    if (queryTodayRecrod.success && queryTodayRecrod.results != null) {
      return queryTodayRecrod.results!.first as ParseObject;
    }
    return null;
  }

  Future<ParseResponse> queryAttendance({
    required String attedanceId,
    required String userId,
  }) async {
    final QueryBuilder<ParseObject> attendanceQuery =
        QueryBuilder<ParseObject>(ParseObject(timeAttendancesTable))
          ..whereEqualTo(timeAttendancesTimeInOutIdField, attedanceId)
          ..whereEqualTo(timeAttendancesUserIdField, userId);

    return attendanceQuery.query();
  }

  @override
  Future<APIResponse<Attendance?>> getInitialData() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final String userId = user.objectId!;

        final ParseObject? queryTodayRecrod = await dateRecordInfo();

        if (queryTodayRecrod != null) {
          final ParseResponse attendanceToday = await queryAttendance(
            attedanceId: queryTodayRecrod.objectId!,
            userId: userId,
          );

          if (attendanceToday.error != null) {
            formatAPIErrorResponse(error: attendanceToday.error!);
          }

          if (attendanceToday.results != null &&
              attendanceToday.results!.isNotEmpty) {
            final ParseObject attendanceInfo =
                attendanceToday.results!.first as ParseObject;

            return APIResponse<Attendance?>(
              success: true,
              message: 'Successfully get initial data.',
              data: Attendance(
                id: attendanceInfo.objectId!,
                timeInOutId: queryTodayRecrod.objectId!,
                timeInEpoch:
                    attendanceInfo.get<int>(timeAttendancesTimeInField),
                timeOutEpoch:
                    attendanceInfo.get<int>(timeAttendancesTimeOutField),
                offsetDuration:
                    attendanceInfo.get<int>(timeAttendancesOffsetDurationField),
                offsetStatus: attendanceInfo
                    .get<String>(timeAttendancesOffsetStatusField),
                requiredDuration: attendanceInfo
                    .get<int>(timeAttendancesRequiredDurationField),
              ),
              errorCode: null,
            );
          }
        }
      }
      return APIResponse<Attendance?>(
        success: true,
        message: 'Successfully get initial data.',
        data: null,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<int>> yesterdaysUsersOffSet() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        /// Get yesterday record to get the id.
        final ParseObject? queryYesterdayRecord =
            await dateRecordInfo(today: false);

        /// If there is a record yesterday.
        if (queryYesterdayRecord != null) {
          final ParseResponse attendanceYesterday = await queryAttendance(
            attedanceId: queryYesterdayRecord.objectId!,
            userId: user.objectId!,
          );

          if (attendanceYesterday.error != null) {
            formatAPIErrorResponse(error: attendanceYesterday.error!);
          }

          /// Add check if there is a record yesterday
          if (attendanceYesterday.success && attendanceYesterday.count == 1) {
            final ParseObject resultParseObject =
                getParseObject(attendanceYesterday.results!);

            /// If there is a record yesterday and if the yesterday's offset is approved. Set the current required minute to the offset minutes yesterday.
            if (attendanceYesterday.success &&
                attendanceYesterday.results != null &&
                resultParseObject
                        .get<String>(timeAttendancesOffsetStatusField) ==
                    'APPROVED') {
              return APIResponse<int>(
                success: true,
                message: "Successfully get yesterday's offset",
                data: resultParseObject
                        .get<int>(timeAttendancesOffsetDurationField) ??
                    0,
                errorCode: null,
              );
            }
          }
        }

        return APIResponse<int>(
          success: true,
          message: "Successfully get yesterday's offset",
          data: 0,
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
  Future<APIResponse<Attendance>> signInToday() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      final ParseObject attendance = ParseObject(timeAttendancesTable);

      /// Get the current time record for this day
      final ParseObject? queryTodayRecrod = await dateRecordInfo();

      if (queryTodayRecrod != null && user != null) {
        final String todayRecordId = queryTodayRecrod.objectId!;
        final int timeInEpoch = epochFromDateTime(date: DateTime.now());

        /// total minute of offset yesterday.
        final int requiredTimeDuration = const Duration(hours: 8).inMinutes;

        final APIResponse<int> minuteToMinus = await yesterdaysUsersOffSet();

        /// Subtract the 8hr minute to the yesterday's offset.

        final int totalNewRequiredDuration =
            requiredTimeDuration - minuteToMinus.data;

        final ParseResponse attendanceResponse = await queryAttendance(
          attedanceId: todayRecordId,
          userId: user.objectId!,
        );

        if (attendanceResponse.error != null) {
          formatAPIErrorResponse(error: attendanceResponse.error!);
        }

        /// If there is an already made request throw error.
        if (attendanceResponse.success &&
            attendanceResponse.count == 1 &&
            getParseObject(attendanceResponse.results!)
                    .get<int>(timeAttendancesTimeInField) !=
                null) {
          throw APIErrorResponse(
            message: 'Already requested.',
            errorCode: null,
          );
        }

        if (attendanceResponse.success && attendanceResponse.count == 0) {
          if (todayRecordId.isNotEmpty && user.objectId != null) {
            final ParseObject attendance = ParseObject(timeAttendancesTable)
              ..set<int>(timeAttendancesTimeInField, timeInEpoch)
              ..set<int?>(timeAttendancesTimeOutField, null)
              ..set<String>(timeAttendancesUserIdField, user.objectId!)
              ..set<String>(timeAttendancesTimeInOutIdField, todayRecordId)
              ..set<int>(
                timeAttendancesRequiredDurationField,
                totalNewRequiredDuration,
              );

            final ParseResponse res = await attendance.save();

            if (res.error != null) {
              formatAPIErrorResponse(error: res.error!);
            }

            if (res.success) {
              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully time in today.',
                data: Attendance(
                  id: getResultId(res.results!),
                  timeInOutId: todayRecordId,
                  timeInEpoch: timeInEpoch,
                  requiredDuration: totalNewRequiredDuration,
                ),
                errorCode: null,
              );
            }
          }
        } else if (attendanceResponse.success &&
            attendanceResponse.count == 1) {
          /// If there is a result, just update the row.
          final String attendanceTodayId =
              getResultId(attendanceResponse.results!);

          attendance
            ..objectId = attendanceTodayId
            ..set<int>(timeAttendancesTimeInField, timeInEpoch)
            ..set<int?>(timeAttendancesTimeOutField, null)
            ..set<int>(
              timeAttendancesRequiredDurationField,
              totalNewRequiredDuration,
            );

          final ParseResponse attendanceRecordResponse =
              await attendance.save();

          if (attendanceRecordResponse.error != null) {
            formatAPIErrorResponse(error: attendanceRecordResponse.error!);
          }

          if (attendanceRecordResponse.success) {
            /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
            final String objectId =
                getResultId(attendanceRecordResponse.results!);
            final ParseResponse attendanceRecord =
                await attendance.getObject(objectId);

            if (attendanceRecord.success && attendanceRecord.results != null) {
              final ParseObject resultParseObject =
                  getParseObject(attendanceRecord.results!);

              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully time in today.',
                data: Attendance(
                  id: objectId,
                  timeInOutId: todayRecordId,
                  offsetDuration: resultParseObject
                      .get<int>(timeAttendancesOffsetDurationField),
                  offsetStatus: resultParseObject
                      .get<String>(timeAttendancesOffsetStatusField),
                  timeInEpoch: timeInEpoch,
                  requiredDuration: totalNewRequiredDuration,
                ),
                errorCode: null,
              );
            }
          }
        }
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
  Future<APIResponse<Attendance>> signOutToday() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      final ParseObject? queryTodayRecrod = await dateRecordInfo();

      if (user != null && queryTodayRecrod != null) {
        final String todayRecordId = queryTodayRecrod.objectId!;
        final ParseObject attendance = ParseObject(timeAttendancesTable);

        /// Get the current time record for this day
        final QueryBuilder<ParseObject> attendanceQuery =
            QueryBuilder<ParseObject>(attendance)
              ..whereEqualTo(timeAttendancesTimeInOutIdField, todayRecordId)
              ..whereEqualTo(timeAttendancesUserIdField, user.objectId);

        final ParseResponse attendanceResponse = await attendanceQuery.query();

        if (attendanceResponse.error != null) {
          formatAPIErrorResponse(error: attendanceResponse.error!);
        }

        if (attendanceResponse.success && attendanceResponse.results != null) {
          final ParseObject attendanceRow =
              getParseObject(attendanceResponse.results!);
          final String attedanceKey = attendanceRow.objectId!;

          final int timeInEpoch =
              attendanceRow.get<int>(timeAttendancesTimeInField)!;
          final int timeOutEpoch = epochFromDateTime(date: DateTime.now());

          attendance
            ..objectId = attedanceKey
            ..set<int>(timeAttendancesTimeOutField, timeOutEpoch);

          final ParseResponse saveTimeOutRes = await attendance.save();

          if (saveTimeOutRes.success) {
            return APIResponse<Attendance>(
              success: true,
              message: 'Successfully time out today.',
              data: Attendance(
                id: attedanceKey,
                timeInOutId: todayRecordId,
                timeInEpoch: timeInEpoch,
                timeOutEpoch: timeOutEpoch,
                requiredDuration: attendanceRow
                    .get<int>(timeAttendancesRequiredDurationField),
              ),
              errorCode: null,
            );
          }
        }
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
  Future<APIResponse<Attendance>> requestOffSet({
    required int hours,
    required int minutes,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      final ParseObject? queryTodayRecord = await dateRecordInfo();

      if (user != null && queryTodayRecord != null) {
        final String todayRecordId = queryTodayRecord.objectId!;
        final ParseObject attendance = ParseObject(timeAttendancesTable);
        final int getMinutesfOffset =
            Duration(hours: hours, minutes: minutes).inMinutes;
        const String offsetStatus = 'PENDING';

        /// Get the current time record for this day
        final QueryBuilder<ParseObject> attendanceQuery =
            QueryBuilder<ParseObject>(attendance)
              ..whereEqualTo(timeAttendancesTimeInOutIdField, todayRecordId)
              ..whereEqualTo(timeAttendancesUserIdField, user.objectId);

        final ParseResponse attendanceResponse = await attendanceQuery.query();

        if (attendanceResponse.error != null) {
          formatAPIErrorResponse(error: attendanceResponse.error!);
        }

        /// If there is an already made request throw error.
        if (attendanceResponse.success &&
            attendanceResponse.count == 1 &&
            (getParseObject(attendanceResponse.results!)
                        .get<int>(timeAttendancesOffsetDurationField) !=
                    null &&
                getParseObject(attendanceResponse.results!)
                        .get<String>(timeAttendancesOffsetStatusField) !=
                    null)) {
          throw APIErrorResponse(
            message: 'Already requested',
            errorCode: null,
          );
        }

        /// If there is no result. Create new row.
        if (attendanceResponse.success && attendanceResponse.count == 0) {
          final int requiredTimeDuration = const Duration(hours: 8).inMinutes;

          final ParseObject attendance = ParseObject(timeAttendancesTable)
            ..set<int?>(timeAttendancesTimeInField, null)
            ..set<int?>(timeAttendancesTimeOutField, null)
            ..set<String>(timeAttendancesUserIdField, user.objectId!)
            ..set<String>(timeAttendancesTimeInOutIdField, todayRecordId)
            ..set<int>(timeAttendancesOffsetDurationField, getMinutesfOffset)
            ..set<String>(timeAttendancesOffsetStatusField, offsetStatus)
            ..set<int>(
              timeAttendancesRequiredDurationField,
              requiredTimeDuration,
            );

          final ParseResponse attendanceRecordResponse =
              await attendance.save();

          if (attendanceRecordResponse.error != null) {
            formatAPIErrorResponse(error: attendanceRecordResponse.error!);
          }

          if (attendanceRecordResponse.success) {
            return APIResponse<Attendance>(
              success: true,
              message: 'Successfully requested offset.',
              data: Attendance(
                id: getResultId(attendanceRecordResponse.results!),
                timeInOutId: todayRecordId,
                offsetDuration: getMinutesfOffset,
                offsetStatus: offsetStatus,
              ),
              errorCode: null,
            );
          }
        } else if (attendanceResponse.success &&
            attendanceResponse.count == 1) {
          /// If there is a result, just update the row.
          final String attendanceTodayId =
              getResultId(attendanceResponse.results!);

          attendance
            ..objectId = attendanceTodayId
            ..set<int>(timeAttendancesOffsetDurationField, getMinutesfOffset)
            ..set<String>(timeAttendancesOffsetStatusField, offsetStatus);

          final ParseResponse attendanceRecordResponse =
              await attendance.save();

          if (attendanceRecordResponse.error != null) {
            formatAPIErrorResponse(error: attendanceRecordResponse.error!);
          }

          if (attendanceRecordResponse.success) {
            /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
            final String objectId =
                getResultId(attendanceRecordResponse.results!);
            final ParseResponse attendanceRecord =
                await attendance.getObject(objectId);

            if (attendanceRecord.success && attendanceRecord.results != null) {
              final ParseObject resultParseObject =
                  getParseObject(attendanceRecord.results!);

              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully requested offset.',
                data: Attendance(
                  id: objectId,
                  timeInOutId: todayRecordId,
                  offsetDuration: getMinutesfOffset,
                  offsetStatus: offsetStatus,
                  timeInEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeInField),
                  timeOutEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeOutField),
                ),
                errorCode: null,
              );
            }
          }
        }
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
  Future<APIListResponse<Attendance>> getAllOffsetRequest({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject attendance = ParseObject(timeAttendancesTable);
        final QueryBuilder<ParseObject> listOfRequests =
            QueryBuilder<ParseObject>(attendance)
              ..whereEqualTo(timeAttendancesOffsetStatusField, 'PENDING');

        if (startDate != null && endDate != null) {
          listOfRequests
            ..whereGreaterThanOrEqualsTo('createdAt', startDate)
            ..whereLessThan('createdAt', endDate);
        }

        final ParseResponse offsetRequestResponse =
            await listOfRequests.query();

        if (offsetRequestResponse.error != null) {
          formatAPIErrorResponse(error: offsetRequestResponse.error!);
        }

        if (offsetRequestResponse.success) {
          final List<Attendance> attendances = <Attendance>[];
          if (offsetRequestResponse.results != null) {
            for (final ParseObject result
                in offsetRequestResponse.results! as List<ParseObject>) {
              attendances.add(
                Attendance(
                  id: result.objectId!,
                  timeInOutId: '',
                  timeInEpoch: result.get<int>(timeAttendancesTimeInField),
                  timeOutEpoch: result.get<int>(timeAttendancesTimeOutField),
                  offsetStatus:
                      result.get<String>(timeAttendancesOffsetStatusField),
                  offsetDuration:
                      result.get<int>(timeAttendancesOffsetDurationField),
                  requiredDuration:
                      result.get<int>(timeAttendancesRequiredDurationField),
                ),
              );
            }
          }

          return APIListResponse<Attendance>(
            success: true,
            message: 'Successfully get all request offset.',
            data: attendances,
            errorCode: null,
          );
        }
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
  Future<APIResponse<Attendance>> approveOffset({
    required String attendanceId,
  }) async {
    if (attendanceId.isEmpty) {
      throw APIErrorResponse(
        message: 'Attendance ID cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject attendance = ParseObject(timeAttendancesTable);

        final ParseResponse attedanceResponse =
            await attendance.getObject(attendanceId);

        if (attedanceResponse.error != null) {
          formatAPIErrorResponse(error: attedanceResponse.error!);
        }

        if (attedanceResponse.success && attedanceResponse.results != null) {
          final ParseObject resultParseObject =
              getParseObject(attedanceResponse.results!);

          final int requestedDurationOffset =
              resultParseObject.get<int>(timeAttendancesOffsetDurationField)!;
          final int requiredDuration =
              resultParseObject.get<int>(timeAttendancesRequiredDurationField)!;

          final int totalNewRequiredDuration =
              requestedDurationOffset + requiredDuration;

          attendance
            ..objectId = attendanceId
            ..set<int>(
              timeAttendancesRequiredDurationField,
              totalNewRequiredDuration,
            )
            ..set<String>(timeAttendancesOffsetStatusField, 'APPROVED');

          final ParseResponse approveResponse = await attendance.save();

          if (approveResponse.error != null) {
            formatAPIErrorResponse(error: approveResponse.error!);
          }

          if (approveResponse.success && approveResponse.results != null) {
            /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
            final String objectId = getResultId(approveResponse.results!);
            final ParseResponse timeInResponse =
                await attendance.getObject(objectId);

            if (timeInResponse.error != null) {
              formatAPIErrorResponse(error: timeInResponse.error!);
            }

            if (timeInResponse.success && timeInResponse.results != null) {
              final ParseObject resultParseObject =
                  getParseObject(timeInResponse.results!);

              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully approved offset.',
                data: Attendance(
                  id: resultParseObject.objectId!,
                  timeInOutId: '',
                  timeInEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeInField),
                  timeOutEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeOutField),
                  offsetStatus: resultParseObject
                      .get<String>(timeAttendancesOffsetStatusField),
                  offsetDuration: resultParseObject
                      .get<int>(timeAttendancesOffsetDurationField),
                  requiredDuration: resultParseObject
                      .get<int>(timeAttendancesRequiredDurationField),
                ),
                errorCode: null,
              );
            }
          }
        }
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
  Future<APIResponse<TimeIn>> updateTimeInHoliday({
    required String id,
    required String holiday,
  }) async {
    if (id.isEmpty || holiday.isEmpty) {
      throw APIErrorResponse(
        message: 'This fields cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject updateTimeInOut = ParseObject(timeInOutsTable);

        updateTimeInOut
          ..objectId = id
          ..set(timeInOutsHolidayIdField, holiday);

        final ParseResponse updateTimeInOutResponse =
            await updateTimeInOut.save();

        if (updateTimeInOutResponse.error != null) {
          formatAPIErrorResponse(error: updateTimeInOutResponse.error!);
        }

        if (updateTimeInOutResponse.success &&
            updateTimeInOutResponse.results != null) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(updateTimeInOutResponse.results!);
          final ParseResponse timeInResponse =
              await updateTimeInOut.getObject(objectId);

          if (timeInResponse.error != null) {
            formatAPIErrorResponse(error: timeInResponse.error!);
          }

          if (timeInResponse.success && timeInResponse.results != null) {
            return APIResponse<TimeIn>(
              success: true,
              message: "Successfully updated today's record",
              data: TimeIn(
                dateEpoch: getParseObject(timeInResponse.results!)
                    .get<int>(timeInOutDateField)!,
                holiday: holiday,
                id: id,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateTimeInOutResponse.error != null
              ? updateTimeInOutResponse.error!.message
              : '',
          errorCode: updateTimeInOutResponse.error != null
              ? updateTimeInOutResponse.error!.code as String
              : '',
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
