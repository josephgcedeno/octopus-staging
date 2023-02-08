import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/time_in_out_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class TimeInOutRepository extends ITimeInOutRepository {
  final DateTime now = DateTime.now();

  DateTime get currentDate => DateTime(now.year, now.month, now.day);

  Future<void> createNewDate() async {
    final DateTime date = DateTime(now.year, now.month, now.day);

    final ParseObject timeInOut = ParseObject(timeInOutsTable);
    final QueryBuilder<ParseObject> isTodayPresent =
        QueryBuilder<ParseObject>(timeInOut)
          ..whereGreaterThanOrEqualsTo(
            timeInOutDateField,
            epochFromDateTime(date: date),
          )
          ..whereLessThan(
            timeInOutDateField,
            epochFromDateTime(date: DateTime(now.year, now.month, now.day + 1)),
          );

    final ParseResponse responseDsr = await isTodayPresent.query();

    /// If empty create one.
    if (responseDsr.count == 0) {
      final ParseObject timeINOUt = timeInOut
        ..set<String>(timeInOutsHolidayField, '')
        ..set<int>(timeInOutDateField, epochFromDateTime(date: now));

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
                    date: currentDate,
                  )
                : epochFromDateTime(
                    date: DateTime(now.year, now.month, now.day - 1),
                  ),
          )
          ..whereLessThan(
            timeInOutDateField,
            today
                ? epochFromDateTime(
                    date: DateTime(now.year, now.month, now.day + 1),
                  )
                : epochFromDateTime(
                    date: currentDate,
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
  Future<AttendanceResponse?> getInitialData() async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      final String userId = user.objectId!;

      final ParseObject? queryTodayRecrod = await dateRecordInfo();

      if (queryTodayRecrod != null) {
        final ParseResponse attendanceToday = await queryAttendance(
          attedanceId: queryTodayRecrod.objectId!,
          userId: userId,
        );

        if (attendanceToday.results != null &&
            attendanceToday.results!.isNotEmpty) {
          final ParseObject attendanceInfo =
              attendanceToday.results!.first as ParseObject;

          return AttendanceResponse(
            status: 'success',
            attendances: <Attendance>[
              Attendance(
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
            ],
          );
        }
      }
    }
    return null;
  }

  @override
  Future<int> yesterdaysUsersOffSet() async {
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

        /// Add check if there is a record yesterday
        if (attendanceYesterday.success && attendanceYesterday.count == 1) {
          final ParseObject resultParseObject =
              getParseObject(attendanceYesterday.results!);

          /// If there is a record yesterday and if the yesterday's offset is approved. Set the current required minute to the offset minutes yesterday.
          if (attendanceYesterday.success &&
              attendanceYesterday.results != null &&
              resultParseObject.get<String>(timeAttendancesOffsetStatusField) ==
                  'APPROVED') {
            return resultParseObject
                    .get<int>(timeAttendancesOffsetDurationField) ??
                0;
          }
        }
      }
    }
    return 0;
  }

  @override
  Future<AttendanceResponse> signInToday() async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    final ParseObject attendance = ParseObject(timeAttendancesTable);

    /// Get the current time record for this day
    final ParseObject? queryTodayRecrod = await dateRecordInfo();

    if (queryTodayRecrod != null && user != null) {
      final String todayRecordId = queryTodayRecrod.objectId!;
      final int timeInEpoch = epochFromDateTime(date: DateTime.now());

      /// total minute of offset yesterday.
      final int requiredTimeDuration = const Duration(hours: 8).inMinutes;
      final int minuteToMinus = await yesterdaysUsersOffSet();

      /// Subtract the 8hr minute to the yesterday's offset.

      final int totalNewRequiredDuration = requiredTimeDuration - minuteToMinus;

      final ParseResponse attendanceResponse = await queryAttendance(
        attedanceId: todayRecordId,
        userId: user.objectId!,
      );

      /// If there is an already made request throw error.
      if (attendanceResponse.success &&
          attendanceResponse.count == 1 &&
          getParseObject(attendanceResponse.results!)
                  .get<int>(timeAttendancesTimeInField) !=
              null) {
        throw APIResponse<void>(
          success: false,
          message: 'Already requested.',
          data: null,
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

          if (res.success) {
            return AttendanceResponse(
              status: 'success',
              attendances: <Attendance>[
                Attendance(
                  id: getResultId(res.results!),
                  timeInOutId: todayRecordId,
                  timeInEpoch: timeInEpoch,
                  requiredDuration: totalNewRequiredDuration,
                ),
              ],
            );
          }
        }
      } else if (attendanceResponse.success && attendanceResponse.count == 1) {
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

        final ParseResponse attendanceRecordResponse = await attendance.save();

        if (attendanceRecordResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId =
              getResultId(attendanceRecordResponse.results!);
          final ParseResponse attendanceRecord =
              await attendance.getObject(objectId);

          if (attendanceRecord.success && attendanceRecord.results != null) {
            final ParseObject resultParseObject =
                getParseObject(attendanceRecord.results!);

            return AttendanceResponse(
              status: 'success',
              attendances: <Attendance>[
                Attendance(
                  id: objectId,
                  timeInOutId: todayRecordId,
                  offsetDuration: resultParseObject
                      .get<int>(timeAttendancesOffsetDurationField),
                  offsetStatus: resultParseObject
                      .get<String>(timeAttendancesOffsetStatusField),
                  timeInEpoch: timeInEpoch,
                  requiredDuration: totalNewRequiredDuration,
                ),
              ],
            );
          }
        }
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<AttendanceResponse> signOutToday() async {
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
          return AttendanceResponse(
            status: 'success',
            attendances: <Attendance>[
              Attendance(
                id: attedanceKey,
                timeInOutId: todayRecordId,
                timeInEpoch: timeInEpoch,
                timeOutEpoch: timeOutEpoch,
                requiredDuration: attendanceRow
                    .get<int>(timeAttendancesRequiredDurationField),
              ),
            ],
          );
        }
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<AttendanceResponse> requestOffSet({
    required int hours,
    required int minutes,
  }) async {
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

      /// If there is an already made request throw error.
      if (attendanceResponse.success &&
          attendanceResponse.count == 1 &&
          (getParseObject(attendanceResponse.results!)
                      .get<int>(timeAttendancesOffsetDurationField) !=
                  null &&
              getParseObject(attendanceResponse.results!)
                      .get<String>(timeAttendancesOffsetStatusField) !=
                  null)) {
        throw APIResponse<void>(
          success: false,
          message: 'Already requested',
          data: null,
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

        final ParseResponse attendanceRecordResponse = await attendance.save();

        if (attendanceRecordResponse.success) {
          return AttendanceResponse(
            status: 'success',
            attendances: <Attendance>[
              Attendance(
                id: getResultId(attendanceRecordResponse.results!),
                timeInOutId: todayRecordId,
                offsetDuration: getMinutesfOffset,
                offsetStatus: offsetStatus,
              ),
            ],
          );
        }
      } else if (attendanceResponse.success && attendanceResponse.count == 1) {
        /// If there is a result, just update the row.
        final String attendanceTodayId =
            getResultId(attendanceResponse.results!);

        attendance
          ..objectId = attendanceTodayId
          ..set<int>(timeAttendancesOffsetDurationField, getMinutesfOffset)
          ..set<String>(timeAttendancesOffsetStatusField, offsetStatus);

        final ParseResponse attendanceRecordResponse = await attendance.save();

        if (attendanceRecordResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId =
              getResultId(attendanceRecordResponse.results!);
          final ParseResponse attendanceRecord =
              await attendance.getObject(objectId);

          if (attendanceRecord.success && attendanceRecord.results != null) {
            final ParseObject resultParseObject =
                getParseObject(attendanceRecord.results!);

            return AttendanceResponse(
              status: 'success',
              attendances: <Attendance>[
                Attendance(
                  id: objectId,
                  timeInOutId: todayRecordId,
                  offsetDuration: getMinutesfOffset,
                  offsetStatus: offsetStatus,
                  timeInEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeInField),
                  timeOutEpoch:
                      resultParseObject.get<int>(timeAttendancesTimeOutField),
                ),
              ],
            );
          }
        }
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<AttendanceResponse> getAllOffsetRequest({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
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

      final ParseResponse offsetRequestResponse = await listOfRequests.query();

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

        return AttendanceResponse(
          attendances: attendances,
          status: 'success',
        );
      }

      /// If empty
      if (offsetRequestResponse.success &&
          offsetRequestResponse.results == null &&
          offsetRequestResponse.error!.message ==
              'Successful request, but no results found') {
        return AttendanceResponse(
          attendances: <Attendance>[],
          status: 'success',
        );
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<AttendanceResponse> approveOffset({
    required String attendanceId,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject attendance = ParseObject(timeAttendancesTable);

      final ParseResponse attedanceResponse =
          await attendance.getObject(attendanceId);

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

        if (approveResponse.success && approveResponse.results != null) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(approveResponse.results!);
          final ParseResponse timeInResponse =
              await attendance.getObject(objectId);

          if (timeInResponse.success && timeInResponse.results != null) {
            final ParseObject resultParseObject =
                getParseObject(timeInResponse.results!);

            return AttendanceResponse(
              status: 'success',
              attendances: <Attendance>[
                Attendance(
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
              ],
            );
          }
        }
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<TimeInResponse> updateTimeInHoliday({
    required String id,
    required String holiday,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject updateTimeInOut = ParseObject(timeInOutsTable);

      updateTimeInOut
        ..objectId = id
        ..set(timeInOutsHolidayField, holiday);

      final ParseResponse updateTimeInOutResponse =
          await updateTimeInOut.save();

      if (updateTimeInOutResponse.success &&
          updateTimeInOutResponse.results != null) {
        /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
        final String objectId = getResultId(updateTimeInOutResponse.results!);
        final ParseResponse timeInResponse =
            await updateTimeInOut.getObject(objectId);

        if (timeInResponse.success && timeInResponse.results != null) {
          return TimeInResponse(
            status: 'success',
            timeIn: TimeIn(
              dateEpoch: getParseObject(timeInResponse.results!)
                  .get<int>(timeInOutDateField)!,
              holiday: holiday,
              id: id,
            ),
          );
        }
      }

      throw APIResponse<void>(
        success: false,
        message: updateTimeInOutResponse.error != null
            ? updateTimeInOutResponse.error!.message
            : '',
        data: null,
        errorCode: updateTimeInOutResponse.error != null
            ? updateTimeInOutResponse.error!.code as String
            : '',
      );
    }
    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }
}
