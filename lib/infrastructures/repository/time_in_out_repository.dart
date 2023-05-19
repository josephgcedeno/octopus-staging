import 'dart:io';

import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TimeInOutRepository extends ITimeInOutRepository {
  final DateTime _now = DateTime.now();

  DateTime get _currentDate => DateTime(_now.year, _now.month, _now.day);

  /// This function will check if today is holiday, if it is holiday, return the parse object for the record for this holiday such as ID.
  Future<HolidayParseObject?> todayHoliday(
    DateTime today,
  ) async {
    final HolidayParseObject holiday = HolidayParseObject();
    final QueryBuilder<HolidayParseObject> holidayTodayQuery =
        QueryBuilder<HolidayParseObject>(holiday)
          ..whereEqualTo(
            HolidayParseObject.keyDate,
            epochFromDateTime(date: today),
          );

    final ParseResponse holidayTodayQueryResponse =
        await holidayTodayQuery.query();

    if (holidayTodayQueryResponse.success) {
      if (holidayTodayQueryResponse.results != null) {
        return HolidayParseObject.toCustomParseObject(
          data: holidayTodayQueryResponse.results!.first,
        );
      }
    }

    return null;
  }

  /// Get record only from yesterday or today. If today is set to false. Get the record from yesterday. If today is true. Get the record for today.
  Future<TimeInOutParseObject?> dateRecordInfo({
    bool today = true,
  }) async {
    final QueryBuilder<TimeInOutParseObject> todayRecord =
        QueryBuilder<TimeInOutParseObject>(TimeInOutParseObject())
          ..whereGreaterThanOrEqualsTo(
            TimeInOutParseObject.keyDate,
            today
                ? epochFromDateTime(
                    date: _currentDate,
                  )
                : epochFromDateTime(
                    date: DateTime(_now.year, _now.month, _now.day - 1),
                  ),
          )
          ..whereLessThan(
            TimeInOutParseObject.keyDate,
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
      return TimeInOutParseObject.toCustomParseObject(
        data: queryTodayRecrod.results!.first,
      );
    }
    return null;
  }

  Future<ParseResponse> queryAttendance({
    required String attedanceId,
    required String userId,
  }) async {
    final QueryBuilder<TimeAttendancesParseObject> attendanceQuery =
        QueryBuilder<TimeAttendancesParseObject>(TimeAttendancesParseObject())
          ..whereEqualTo(
            TimeAttendancesParseObject.keyTimeInOut,
            TimeInOutParseObject()..objectId = attedanceId,
          )
          ..whereEqualTo(
            TimeAttendancesParseObject.keyUser,
            ParseUser.forQuery()..objectId = userId,
          )
          ..includeObject(
            <String>[
              TimeAttendancesParseObject.keyUser,
              TimeAttendancesParseObject.keyTimeInOut
            ],
          );

    return attendanceQuery.query();
  }

  @override
  Future<APIResponse<Attendance?>> getInitialData() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final String userId = user.objectId!;

        final TimeInOutParseObject? queryTodayRecrod = await dateRecordInfo();

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
            final TimeAttendancesParseObject attendanceInfo =
                TimeAttendancesParseObject.toCustomParseObject(
              data: attendanceToday.results!.first,
            );

            return APIResponse<Attendance?>(
              success: true,
              message: 'Successfully get initial data.',
              data: Attendance(
                id: attendanceInfo.objectId!,
                timeInOutId: queryTodayRecrod.objectId!,
                timeInEpoch: attendanceInfo.timeIn,
                timeOutEpoch: attendanceInfo.timeOut,
                offsetDuration: attendanceInfo.offsetDuration,
                offsetStatus: attendanceInfo.offsetStatus,
                requiredDuration: attendanceInfo.requiredDuration,
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
                resultParseObject.get<String>(
                      TimeAttendancesParseObject.keyOffsetStatus,
                    ) ==
                    approved) {
              return APIResponse<int>(
                success: true,
                message: "Successfully get yesterday's offset",
                data: resultParseObject.get<int>(
                      TimeAttendancesParseObject.keyOffsetDuration,
                    ) ??
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
      final TimeAttendancesParseObject attendance =
          TimeAttendancesParseObject();

      /// Get the current time record for this day
      final TimeInOutParseObject? queryTodayRecrod = await dateRecordInfo();

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
                    .get<int>(TimeAttendancesParseObject.keyTimeIn) !=
                null) {
          throw APIErrorResponse(
            message: 'Already requested.',
            errorCode: null,
          );
        }

        if (attendanceResponse.success && attendanceResponse.count == 0) {
          if (todayRecordId.isNotEmpty && user.objectId != null) {
            attendance
              ..timeIn = timeInEpoch
              ..timeOut = null
              ..user = (ParseUser.forQuery()..objectId = user.objectId)
              ..timeInOut = (TimeInOutParseObject()..objectId = todayRecordId)
              ..requiredDuration = totalNewRequiredDuration;

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
            ..timeIn = timeInEpoch
            ..timeOut = null
            ..requiredDuration = totalNewRequiredDuration;

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
              final TimeAttendancesParseObject resultParseObject =
                  TimeAttendancesParseObject.toCustomParseObject(
                data: attendanceRecord.results!.first,
              );

              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully time in today.',
                data: Attendance(
                  id: objectId,
                  timeInOutId: todayRecordId,
                  offsetDuration: resultParseObject.offsetDuration,
                  offsetStatus: resultParseObject.offsetStatus,
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
      final TimeInOutParseObject? queryTodayRecrod = await dateRecordInfo();

      if (user != null && queryTodayRecrod != null) {
        final String todayRecordId = queryTodayRecrod.objectId!;
        final TimeAttendancesParseObject attendance =
            TimeAttendancesParseObject();

        /// Get the current time record for this day
        final QueryBuilder<TimeAttendancesParseObject> attendanceQuery =
            QueryBuilder<TimeAttendancesParseObject>(attendance)
              ..whereEqualTo(
                TimeAttendancesParseObject.keyTimeInOut,
                TimeInOutParseObject()..objectId = todayRecordId,
              )
              ..whereEqualTo(
                TimeAttendancesParseObject.keyUser,
                ParseUser.forQuery()..objectId = user.objectId,
              );

        final ParseResponse attendanceResponse = await attendanceQuery.query();

        if (attendanceResponse.error != null) {
          formatAPIErrorResponse(error: attendanceResponse.error!);
        }

        if (attendanceResponse.success && attendanceResponse.results != null) {
          final TimeAttendancesParseObject attendanceRow =
              TimeAttendancesParseObject.toCustomParseObject(
            data: attendanceResponse.results!.first,
          );

          final String attedanceKey = attendanceRow.objectId!;

          final int timeInEpoch = attendanceRow.timeIn!;

          final int timeOutEpoch = epochFromDateTime(date: DateTime.now());

          attendance
            ..objectId = attedanceKey
            ..timeOut = timeOutEpoch;

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
                requiredDuration: attendanceRow.requiredDuration,
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
    required Duration offsetDuration,
    required String fromTime,
    required String toTime,
    required String reason,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      final ParseObject? queryTodayRecord = await dateRecordInfo();

      if (user != null && queryTodayRecord != null) {
        final String todayRecordId = queryTodayRecord.objectId!;
        final TimeAttendancesParseObject attendance =
            TimeAttendancesParseObject();
        final int getMinutesfOffset = offsetDuration.inMinutes;
        const String offsetStatus = pending;

        /// Get the current time record for this day
        final QueryBuilder<TimeAttendancesParseObject> attendanceQuery =
            QueryBuilder<TimeAttendancesParseObject>(attendance)
              ..whereEqualTo(
                TimeAttendancesParseObject.keyTimeInOut,
                TimeInOutParseObject()..objectId = todayRecordId,
              )
              ..whereEqualTo(
                TimeAttendancesParseObject.keyUser,
                user..objectId = user.objectId,
              );

        final ParseResponse attendanceResponse = await attendanceQuery.query();

        if (attendanceResponse.error != null) {
          formatAPIErrorResponse(error: attendanceResponse.error!);
        }

        /// If there is an already made request throw error.
        if (attendanceResponse.success &&
            attendanceResponse.count == 1 &&
            (getParseObject(attendanceResponse.results!).get<int>(
                      TimeAttendancesParseObject.keyOffsetDuration,
                    ) !=
                    null &&
                getParseObject(attendanceResponse.results!).get<String>(
                      TimeAttendancesParseObject.keyOffsetStatus,
                    ) !=
                    null)) {
          throw APIErrorResponse(
            message: 'Already requested',
            errorCode: null,
          );
        }

        /// If there is no result. Create new row.
        if (attendanceResponse.success && attendanceResponse.count == 0) {
          final int requiredTimeDuration = const Duration(hours: 8).inMinutes;

          attendance
            ..timeIn = null
            ..timeOut = null
            ..user = (user..objectId = user.objectId)
            ..timeInOut = (TimeInOutParseObject()..objectId = todayRecordId)
            ..offsetDuration = getMinutesfOffset
            ..offsetStatus = offsetStatus
            ..requiredDuration = requiredTimeDuration
            ..offsetFromTime = fromTime
            ..offsetToTime = toTime
            ..offsetReason = reason;

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
            ..offsetDuration = getMinutesfOffset
            ..offsetStatus = offsetStatus
            ..offsetFromTime = fromTime
            ..offsetToTime = toTime
            ..offsetReason = reason;

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
                  timeInEpoch: resultParseObject
                      .get<int>(TimeAttendancesParseObject.keyTimeIn),
                  timeOutEpoch: resultParseObject
                      .get<int>(TimeAttendancesParseObject.keyTimeOut),
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
        final TimeAttendancesParseObject attendance =
            TimeAttendancesParseObject();
        final QueryBuilder<TimeAttendancesParseObject> listOfRequests =
            QueryBuilder<TimeAttendancesParseObject>(attendance)
              ..whereEqualTo(
                TimeAttendancesParseObject.keyOffsetStatus,
                pending,
              );

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
              final TimeAttendancesParseObject row =
                  TimeAttendancesParseObject.toCustomParseObject(data: result);
              attendances.add(
                Attendance(
                  id: result.objectId!,
                  timeInOutId: '',
                  timeInEpoch: row.timeIn,
                  timeOutEpoch: row.timeOut,
                  offsetStatus: row.offsetStatus,
                  offsetDuration: row.offsetDuration,
                  requiredDuration: row.requiredDuration,
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
        final TimeAttendancesParseObject attendance =
            TimeAttendancesParseObject();

        final ParseResponse attedanceResponse =
            await attendance.getObject(attendanceId);

        if (attedanceResponse.error != null) {
          formatAPIErrorResponse(error: attedanceResponse.error!);
        }

        if (attedanceResponse.success && attedanceResponse.results != null) {
          final TimeAttendancesParseObject resultParseObject =
              TimeAttendancesParseObject.toCustomParseObject(
            data: attedanceResponse.results!.first,
          );

          final int requestedDurationOffset = resultParseObject.offsetDuration!;

          final int requiredDuration = resultParseObject.requiredDuration!;

          final int totalNewRequiredDuration =
              requestedDurationOffset + requiredDuration;

          attendance
            ..objectId = attendanceId
            ..requiredDuration = totalNewRequiredDuration
            ..offsetStatus = approved;

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
              final TimeAttendancesParseObject resultParseObject =
                  TimeAttendancesParseObject.toCustomParseObject(
                data: timeInResponse.results!.first,
              );

              return APIResponse<Attendance>(
                success: true,
                message: 'Successfully approved offset.',
                data: Attendance(
                  id: resultParseObject.objectId!,
                  timeInOutId: '',
                  timeInEpoch: resultParseObject.timeIn,
                  timeOutEpoch: resultParseObject.timeOut,
                  offsetStatus: resultParseObject.offsetStatus,
                  offsetDuration: resultParseObject.offsetDuration,
                  requiredDuration: resultParseObject.requiredDuration,
                ),
                errorCode: null,
              );
            }
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

  @override
  Future<APIResponse<TimeIn>> updateTimeInHoliday({
    required String id,
    required String holidayId,
  }) async {
    if (id.isEmpty || holidayId.isEmpty) {
      throw APIErrorResponse(
        message: 'This fields cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final TimeInOutParseObject updateTimeInOut = TimeInOutParseObject();

        updateTimeInOut
          ..objectId = id
          ..holiday = (HolidayParseObject()..objectId = holidayId);

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
                    .get<int>(TimeInOutParseObject.keyDate)!,
                holiday: holidayId,
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
  Future<APIListResponse<UserAttendance>> fetchAttendances({
    required List<User> users,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  }) async {
    if (users.isEmpty) {
      throw APIErrorResponse(
        message: 'Users field cannot be empty',
        errorCode: null,
      );
    } else if (today == null && (from == null && to == null)) {
      throw APIErrorResponse(
        message:
            'Date must not be all null. Either today or date range should be filled.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final TimeInOutParseObject timeInOutParseObject =
            TimeInOutParseObject();
        final TimeAttendancesParseObject timeAttendancesParseObject =
            TimeAttendancesParseObject();

        final QueryBuilder<TimeInOutParseObject> queryUsersAttendance =
            QueryBuilder<TimeInOutParseObject>(timeInOutParseObject);

        if (today != null) {
          final DateTime startDate =
              DateTime(today.year, today.month, today.day);
          final DateTime endDate =
              DateTime(today.year, today.month, today.day, 23, 59, 59);

          queryUsersAttendance
            ..whereGreaterThanOrEqualsTo(
              TimeInOutParseObject.keyDate,
              epochFromDateTime(
                date: startDate,
              ),
            )
            ..whereLessThanOrEqualTo(
              TimeInOutParseObject.keyDate,
              epochFromDateTime(
                date: endDate,
              ),
            );
        } else if (from != null && to != null) {
          queryUsersAttendance
            ..whereGreaterThanOrEqualsTo(
              TimeInOutParseObject.keyDate,
              epochFromDateTime(date: from),
            )
            ..whereLessThanOrEqualTo(
              TimeInOutParseObject.keyDate,
              epochFromDateTime(date: to),
            );
        }

        final List<UserAttendance> userAttendances = <UserAttendance>[];

        for (final User userRecord in users) {
          final String userId = userRecord.userId;
          final QueryBuilder<TimeAttendancesParseObject> queryTimeAttendances =
              QueryBuilder<TimeAttendancesParseObject>(
            timeAttendancesParseObject,
          );

          queryTimeAttendances
            ..whereEqualTo(
              TimeAttendancesParseObject.keyUser,
              ParseUser.forQuery()..objectId = userId,
            )
            ..whereMatchesQuery(
              TimeAttendancesParseObject.keyTimeInOut,
              queryUsersAttendance,
            )
            ..includeObject(
              <String>[
                TimeAttendancesParseObject.keyTimeInOut,
              ],
            );

          final ParseResponse queryTimeAttendancesResponse =
              await queryTimeAttendances.query();

          if (queryTimeAttendancesResponse.error != null) {
            formatAPIErrorResponse(error: queryTimeAttendancesResponse.error!);
          }
          final List<Attendance> attendances = <Attendance>[];

          if (queryTimeAttendancesResponse.success &&
              queryTimeAttendancesResponse.count > 0) {
            final List<TimeAttendancesParseObject> allTimeInInfoCasted =
                List<TimeAttendancesParseObject>.from(
              queryTimeAttendancesResponse.results ?? <dynamic>[],
            );

            for (final TimeAttendancesParseObject attendance
                in allTimeInInfoCasted) {
              attendances.add(
                Attendance(
                  id: attendance.objectId!,
                  timeInOutId: attendance.timeInOut.objectId!,
                  timeInEpoch: attendance.timeIn,
                  timeOutEpoch: attendance.timeOut,
                  offsetStatus: attendance.offsetStatus,
                  offsetDuration: attendance.offsetDuration,
                  requiredDuration: attendance.requiredDuration,
                  date: attendance.timeInOut.date,
                ),
              );
            }
          }
          userAttendances.add(
            UserAttendance(
              attendances: attendances,
              userId: userId,
            ),
          );
        }
        return APIListResponse<UserAttendance>(
          success: true,
          message: 'Successfully fetched attendances.',
          data: userAttendances,
          errorCode: null,
        );
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
