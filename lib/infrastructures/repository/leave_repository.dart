import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/leave_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LeaveRepository extends ILeaveRepository {
  void checkFieldIsEmpty(List<String> fields) {
    for (final String field in fields) {
      if (field.isEmpty) {
        throw APIErrorResponse(
          message: 'This field cannot be empty!',
          errorCode: null,
        );
      }
    }
  }

  /// Get the current day.
  DateTime get currentDay => DateTime.now();

  @override
  Future<APIResponse<Leave>> createLeave({
    required int noLeaves,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final int startDateEpoch = epochFromDateTime(date: startDate);
        final int endDateEpoch = epochFromDateTime(date: endDate);
        final LeavesParseObject leaves = LeavesParseObject()
          ..noLeaves = noLeaves
          ..startDate = startDateEpoch
          ..endDate = endDateEpoch;

        final ParseResponse createLeaveResponse = await leaves.save();

        if (createLeaveResponse.error != null) {
          formatAPIErrorResponse(error: createLeaveResponse.error!);
        }

        if (createLeaveResponse.success &&
            createLeaveResponse.results != null) {
          return APIResponse<Leave>(
            success: true,
            message: 'Successfully created leave',
            data: Leave(
              id: getResultId(createLeaveResponse.results!),
              startDateEpoch: startDateEpoch,
              noLeaves: noLeaves,
              endDateEpoch: endDateEpoch,
            ),
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
  Future<APIListResponse<Leave>> getAllLeaves({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesParseObject leaves = LeavesParseObject();
        final QueryBuilder<LeavesParseObject> leavesQuery =
            QueryBuilder<LeavesParseObject>(leaves);

        if (startDate != null && endDate != null) {
          leavesQuery
            ..whereGreaterThanOrEqualsTo(
              LeavesParseObject.keyStartDate,
              epochFromDateTime(date: startDate),
            )
            ..whereLessThan(
              LeavesParseObject.keyEndDate,
              epochFromDateTime(date: endDate),
            );
        }

        final ParseResponse getAllLeaveResponse =
            startDate != null && endDate != null
                ? await leavesQuery.query()
                : await leaves.getAll();

        if (getAllLeaveResponse.error != null) {
          formatAPIErrorResponse(error: getAllLeaveResponse.error!);
        }

        if (getAllLeaveResponse.success) {
          final List<Leave> leaves = <Leave>[];

          if (getAllLeaveResponse.results != null) {
            for (final ParseObject leave
                in getAllLeaveResponse.results! as List<ParseObject>) {
              final LeavesParseObject record =
                  LeavesParseObject.toCustomParseObject(data: leave);

              leaves.add(
                Leave(
                  id: record.objectId!,
                  startDateEpoch: record.startDate,
                  endDateEpoch: record.endDate,
                  noLeaves: record.noLeaves,
                ),
              );
            }
          }

          return APIListResponse<Leave>(
            success: true,
            message: 'Successfully get all leaves.',
            data: leaves,
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
  Future<APIResponse<Leave>> updateLeave({
    required String id,
    int? noLeaves,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    checkFieldIsEmpty(<String>[id]);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesParseObject leaves = LeavesParseObject();

        leaves.objectId = id;

        if (noLeaves != null) {
          leaves.noLeaves = noLeaves;
        }
        if (startDate != null && endDate != null) {
          leaves
            ..startDate = epochFromDateTime(date: startDate)
            ..endDate = epochFromDateTime(date: endDate);
        }

        final ParseResponse updateVacationResponse = await leaves.save();

        if (updateVacationResponse.error != null) {
          formatAPIErrorResponse(error: updateVacationResponse.error!);
        }

        if (updateVacationResponse.success) {
          final ParseResponse getVacationInfoResponse =
              await leaves.getObject(id);

          if (getVacationInfoResponse.success &&
              getVacationInfoResponse.results != null) {
            final LeavesParseObject resultParseObject =
                LeavesParseObject.toCustomParseObject(
              data: getVacationInfoResponse.results!.first,
            );

            return APIResponse<Leave>(
              success: true,
              message: 'Successfull updated leave',
              data: Leave(
                id: id,
                noLeaves: resultParseObject.noLeaves,
                startDateEpoch: resultParseObject.startDate,
                endDateEpoch: resultParseObject.endDate,
              ),
              errorCode: null,
            );
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
  Future<APIResponse<void>> deleteLeave({required String id}) async {
    checkFieldIsEmpty(<String>[id]);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesParseObject leaves = LeavesParseObject();

        final ParseResponse deleteVacationResponse =
            await leaves.delete(id: id);

        if (deleteVacationResponse.error != null) {
          formatAPIErrorResponse(error: deleteVacationResponse.error!);
        }

        if (deleteVacationResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted leave.',
            data: null,
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
  Future<APIResponse<LeaveRequest>> approveRequestLeave({
    required String requestId,
  }) async {
    checkFieldIsEmpty(<String>[requestId]);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesRequestsParseObject leaveRequests =
            LeavesRequestsParseObject();

        leaveRequests
          ..objectId = requestId
          ..status = 'APPROVED';

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.error != null) {
          formatAPIErrorResponse(error: updateReqRecordResponse.error!);
        }

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final LeavesRequestsParseObject leaveReq =
                LeavesRequestsParseObject.toCustomParseObject(
              data: getUpdatedRecordResponse.results!.first,
            );

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully approved leave request.',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.leave.objectId!,
                userId: leaveReq.user.objectId!,
                dateFiledEpoch: leaveReq.dateFiled,
                dateUsedEpoch: leaveReq.dateUsed!,
                leaveType: leaveReq.leaveType,
                reason: leaveReq.reason,
                status: leaveReq.status,
                dateFromEpoch: leaveReq.leaveDateFrom,
                dateToEpoch: leaveReq.leaveDateTo,
                declineReason: leaveReq.declineReason,
              ),
              errorCode: null,
            );
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
  Future<APIResponse<LeaveRequest>> cancelRequestLeave({
    required String requestId,
  }) async {
    checkFieldIsEmpty(<String>[requestId]);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final LeavesRequestsParseObject leaveRequests =
            LeavesRequestsParseObject();

        leaveRequests
          ..objectId = requestId
          ..status = 'CANCELLED';

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.error != null) {
          formatAPIErrorResponse(error: updateReqRecordResponse.error!);
        }

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final LeavesRequestsParseObject leaveReq =
                LeavesRequestsParseObject.toCustomParseObject(
              data: getUpdatedRecordResponse.results!.first,
            );

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully canceled leave request',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.leave.objectId!,
                userId: leaveReq.user.objectId!,
                dateFiledEpoch: leaveReq.dateFiled,
                dateUsedEpoch: leaveReq.dateUsed!,
                leaveType: leaveReq.leaveType,
                reason: leaveReq.reason,
                status: leaveReq.status,
                dateFromEpoch: leaveReq.leaveDateFrom,
                dateToEpoch: leaveReq.leaveDateTo,
                declineReason: leaveReq.declineReason,
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
  Future<APIResponse<LeaveRequest>> declineRequestLeave({
    required String requestId,
    required String declineReason,
  }) async {
    checkFieldIsEmpty(<String>[requestId, declineReason]);
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesRequestsParseObject leaveRequests =
            LeavesRequestsParseObject();

        leaveRequests
          ..objectId = requestId
          ..status = 'DECLINED'
          ..declineReason = declineReason;

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.error != null) {
          formatAPIErrorResponse(error: updateReqRecordResponse.error!);
        }

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final LeavesRequestsParseObject leaveReq =
                LeavesRequestsParseObject.toCustomParseObject(
              data: getUpdatedRecordResponse.results!.first,
            );

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully declined leave request.',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.leave.objectId!,
                userId: leaveReq.user.objectId!,
                dateFiledEpoch: leaveReq.dateFiled,
                dateUsedEpoch: leaveReq.dateUsed!,
                leaveType: leaveReq.leaveType,
                reason: leaveReq.reason,
                status: leaveReq.status,
                dateFromEpoch: leaveReq.leaveDateFrom,
                dateToEpoch: leaveReq.leaveDateTo,
                declineReason: leaveReq.declineReason,
              ),
              errorCode: null,
            );
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
  Future<APIListResponse<LeaveRequest>> getRequestLeaves({
    String? leaveRequestId,
    String? leaveId,
    String? userId,
    String status = 'PENDING',
  }) async {
    const List<String> statues = <String>[
      'CANCELLED',
      'PENDING',
      'DECLINED',
      'APPROVED'
    ];
    if (!statues.contains(status)) {
      throw APIErrorResponse(
        message:
            'Status $status does not match to the specified fields. It must be either $statues',
        errorCode: null,
      );
    }
    try {
      final LeavesRequestsParseObject leaveRequests =
          LeavesRequestsParseObject();
      final EmployeeInfoParseObject employeeInfoParseObject =
          EmployeeInfoParseObject();
      final ParseResponse employeeResponse =
          await employeeInfoParseObject.getAll();

      if (employeeResponse.error != null) {
        formatAPIErrorResponse(error: employeeResponse.error!);
      }

      final List<EmployeeInfoParseObject> allEmployeeCasted =
          List<EmployeeInfoParseObject>.from(
        employeeResponse.results ?? <dynamic>[],
      );

      final QueryBuilder<LeavesRequestsParseObject> leaveReqQuery =
          QueryBuilder<LeavesRequestsParseObject>(leaveRequests)
            ..whereEqualTo(LeavesRequestsParseObject.keyStatus, status)
            ..orderByDescending('createdAt');

      if (leaveRequestId != null) checkFieldIsEmpty(<String>[leaveRequestId]);

      if (leaveId != null) {
        checkFieldIsEmpty(<String>[leaveId]);

        leaveReqQuery.whereEqualTo(
          LeavesRequestsParseObject.keyLeave,
          LeavesParseObject()..objectId = leaveId,
        );
      }
      if (userId != null) {
        checkFieldIsEmpty(<String>[userId]);

        leaveReqQuery.whereEqualTo(
          LeavesRequestsParseObject.keyUser,
          ParseUser.forQuery()..objectId = userId,
        );
      }

      final ParseResponse getLeaveReqResponse = leaveRequestId != null
          ? await leaveRequests.getObject(leaveRequestId)
          : await leaveReqQuery.query();

      if (getLeaveReqResponse.error != null) {
        formatAPIErrorResponse(error: getLeaveReqResponse.error!);
      }

      if (getLeaveReqResponse.success) {
        final List<LeaveRequest> leaveRequests = <LeaveRequest>[];

        if (getLeaveReqResponse.results != null) {
          for (final ParseObject leaveRequest
              in getLeaveReqResponse.results! as List<ParseObject>) {
            final LeavesRequestsParseObject record =
                LeavesRequestsParseObject.toCustomParseObject(
              data: leaveRequest,
            );

            final EmployeeInfoParseObject singleEmployeeInfo =
                allEmployeeCasted.firstWhere(
              (EmployeeInfoParseObject obj) =>
                  obj.user.objectId == record.user.objectId,
            );

            final String userName =
                '${singleEmployeeInfo.firstName} ${singleEmployeeInfo.lastName}';

            leaveRequests.add(
              LeaveRequest(
                id: record.objectId!,
                leaveId: record.leave.objectId!,
                userId: record.user.objectId!,
                dateFiledEpoch: record.dateFiled,
                dateUsedEpoch: record.dateUsed!,
                status: record.status,
                leaveType: record.leaveType,
                reason: record.reason,
                dateFromEpoch: record.leaveDateFrom,
                dateToEpoch: record.leaveDateTo,
                userName: userName,
                declineReason: record.declineReason,
              ),
            );
          }
        }
        return APIListResponse<LeaveRequest>(
          success: true,
          message: 'Successfully get request leaves.',
          data: leaveRequests,
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: errorSomethingWentWrong,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  Future<LeavesParseObject> getCurrentYearInfo() async {
    /// Get the current date and query if under in the
    final DateTime datetToQuery =
        DateTime(currentDay.year, currentDay.month, currentDay.day);

    final int dateToQueryEpoch = epochFromDateTime(date: datetToQuery);

    final LeavesParseObject leaves = LeavesParseObject();

    final QueryBuilder<LeavesParseObject> queryRecordThisYear =
        QueryBuilder<LeavesParseObject>(leaves)
          ..whereGreaterThanOrEqualsTo(
            LeavesParseObject.keyEndDate,
            dateToQueryEpoch,
          )
          ..whereLessThanOrEqualTo(
            LeavesParseObject.keyStartDate,
            dateToQueryEpoch,
          );
    final ParseResponse data = await queryRecordThisYear.query();

    if (data.success && data.results != null) {
      return data.results!.first as LeavesParseObject;
    }

    throw 'No record from this day that match the year range';
  }

  @override
  Future<APIResponse<LeaveRequest>> requestLeave({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
    required DateTime from,
    required DateTime to,
  }) async {
    checkFieldIsEmpty(<String>[reason]);

    const List<String> leaveTypes = <String>[
      'SICK LEAVE',
      'VACATION LEAVE',
      'EMERGENCY LEAVE'
    ];

    if (!leaveTypes.contains(leaveType)) {
      throw APIErrorResponse(
        message:
            'Leave type $leaveType does not match to the specified fields. It must be either $leaveTypes',
        errorCode: null,
      );
    }

    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final LeavesRequestsParseObject leaveRequests =
            LeavesRequestsParseObject();

        final LeavesParseObject currentYearLeaveDetails =
            await getCurrentYearInfo();

        final int noLeaves = currentYearLeaveDetails.noLeaves;

        final String currentYearsId = currentYearLeaveDetails.objectId!;

        final String usersId = user.objectId!;

        final ParseResponse getAllLeaveRequestCurrentYear =
            await getLeaveRequestsStatusRecords(
          usersId,
          currentYearsId,
          approved,
        );

        if (getAllLeaveRequestCurrentYear.error != null) {
          formatAPIErrorResponse(error: getAllLeaveRequestCurrentYear.error!);
        }

        if (getAllLeaveRequestCurrentYear.success &&
            getAllLeaveRequestCurrentYear.results != null) {
          final int noLeavesApproved = getAllLeaveRequestCurrentYear.count;
          if (noLeavesApproved >= noLeaves) {
            throw APIErrorResponse(
              message:
                  "You've already reach your maximum number of leaves for this year which is $noLeavesApproved out of $noLeaves.",
              errorCode: null,
            );
          }
        }

        final int dateFiledEpoch = epochFromDateTime(
          date: DateTime(currentDay.year, currentDay.month, currentDay.day),
        );

        final int dateUsedEpoch = epochFromDateTime(date: dateUsed);

        final int dateFromEpoch = epochFromDateTime(date: from);

        final int dateToEpoch = epochFromDateTime(date: to);

        const String status = 'PENDING';

        leaveRequests
          ..leave = (LeavesParseObject()..objectId = currentYearsId)
          ..user = (ParseUser.forQuery()..objectId = usersId)
          ..dateFiled = dateFiledEpoch
          ..dateUsed = dateUsedEpoch
          ..status = status
          ..reason = reason
          ..leaveType = leaveType
          ..leaveDateFrom = dateFromEpoch
          ..leaveDateTo = dateToEpoch;

        final ParseResponse createLeaveRequestResponse =
            await leaveRequests.save();

        if (createLeaveRequestResponse.error != null) {
          formatAPIErrorResponse(error: createLeaveRequestResponse.error!);
        }

        if (createLeaveRequestResponse.success &&
            createLeaveRequestResponse.results != null) {
          return APIResponse<LeaveRequest>(
            success: true,
            message: 'Successfully requested leave.',
            data: LeaveRequest(
              id: getResultId(createLeaveRequestResponse.results!),
              leaveId: currentYearsId,
              userId: usersId,
              dateFiledEpoch: dateFiledEpoch,
              dateUsedEpoch: dateUsedEpoch,
              status: status,
              leaveType: leaveType,
              reason: reason,
              dateFromEpoch: dateFromEpoch,
              dateToEpoch: dateToEpoch,
            ),
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

  Future<ParseResponse> getLeaveRequestsStatusRecords(
    String userId,
    String leaveYearId,
    String status,
  ) async {
    final LeavesRequestsParseObject leaveRequests = LeavesRequestsParseObject();

    final QueryBuilder<LeavesRequestsParseObject>
        queryGetLeaveRequestForLeaveId =
        QueryBuilder<LeavesRequestsParseObject>(leaveRequests)
          ..whereEqualTo(
            LeavesRequestsParseObject.keyLeave,
            LeavesParseObject()..objectId = leaveYearId,
          )
          ..whereEqualTo(
            LeavesRequestsParseObject.keyUser,
            ParseUser.forQuery()..objectId = userId,
          )
          ..whereEqualTo(LeavesRequestsParseObject.keyStatus, status);

    return queryGetLeaveRequestForLeaveId.query();
  }

  @override
  Future<APIResponse<LeaveRemaining>> getRemainingLeaves({
    required String userId,
    String? leaveId,
  }) async {
    checkFieldIsEmpty(<String>[userId, leaveId ?? 'na']);

    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        late int numberOfLeaves;
        late String leaveYearId;

        if (leaveId != null) {
          leaveYearId = leaveId;

          final LeavesParseObject leaveQuery = LeavesParseObject();
          final ParseResponse leaveRes =
              await leaveQuery.getObject(leaveYearId);

          if (leaveRes.error != null) {
            formatAPIErrorResponse(error: leaveRes.error!);
          }
          if (leaveRes.success && leaveRes.results != null) {
            final LeavesParseObject result =
                leaveRes.results!.first as LeavesParseObject;

            leaveYearId = result.objectId!;
            numberOfLeaves = result.noLeaves;
          }
        } else {
          final LeavesParseObject leaveQuery = await getCurrentYearInfo();

          leaveYearId = leaveQuery.objectId!;
          numberOfLeaves = leaveQuery.noLeaves;
        }

        final ParseResponse getAllLeaveRequestForLeaveId =
            await getLeaveRequestsStatusRecords(userId, leaveYearId, approved);

        if (getAllLeaveRequestForLeaveId.error != null) {
          formatAPIErrorResponse(error: getAllLeaveRequestForLeaveId.error!);
        }

        int approvedRequestsLeaves = 0;
        if (getAllLeaveRequestForLeaveId.success &&
            getAllLeaveRequestForLeaveId.results != null) {
          approvedRequestsLeaves = getAllLeaveRequestForLeaveId.count;
        }
        return APIResponse<LeaveRemaining>(
          success: true,
          message: 'Successfully requested leave.',
          data: LeaveRemaining(
            leaveId: leaveYearId,
            consumedLeave: approvedRequestsLeaves,
            remainingLeave: numberOfLeaves - approvedRequestsLeaves,
          ),
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
  Future<APIListResponse<LeaveRequest>> getAllLeaveRequestForToday() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final LeavesRequestsParseObject leaveRequests =
            LeavesRequestsParseObject();
        final DateTime now = DateTime.now();

        final DateTime currentDate = DateTime(now.year, now.month, now.day);
        final QueryBuilder<LeavesRequestsParseObject> queryRequestsToday =
            QueryBuilder<LeavesRequestsParseObject>(leaveRequests)
              ..whereGreaterThanOrEqualsTo(
                LeavesRequestsParseObject.keyLeaveDateFrom,
                epochFromDateTime(
                  date: currentDate,
                ),
              )
              ..whereLessThan(
                LeavesRequestsParseObject.keyLeaveDateFrom,
                epochFromDateTime(
                  date: DateTime(now.year, now.month, now.day + 1),
                ),
              );

        final ParseResponse getAllLeaveRequestTodayResponse =
            await queryRequestsToday.query();

        if (getAllLeaveRequestTodayResponse.error != null) {
          formatAPIErrorResponse(error: getAllLeaveRequestTodayResponse.error!);
        }
        final List<LeaveRequest> leaveReqs = <LeaveRequest>[];

        if (getAllLeaveRequestTodayResponse.success &&
            getAllLeaveRequestTodayResponse.results != null) {
          final List<LeavesRequestsParseObject> allLeaveRequestsToday =
              List<LeavesRequestsParseObject>.from(
            getAllLeaveRequestTodayResponse.results ?? <dynamic>[],
          );

          for (final LeavesRequestsParseObject leaveReq
              in allLeaveRequestsToday) {
            leaveReqs.add(
              LeaveRequest(
                dateFiledEpoch: leaveReq.dateFiled,
                dateFromEpoch: leaveReq.leaveDateFrom,
                dateToEpoch: leaveReq.leaveDateTo,
                dateUsedEpoch: leaveReq.dateUsed!,
                id: leaveReq.objectId!,
                leaveId: leaveReq.leave.objectId!,
                leaveType: leaveReq.leaveType,
                reason: leaveReq.reason,
                status: leaveReq.status,
                userId: leaveReq.user.objectId!,
              ),
            );
          }
        }
        return APIListResponse<LeaveRequest>(
          success: true,
          message: 'Successfully approved leave request.',
          data: leaveReqs,
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

  @override
  Future<APIListResponse<UserLeaveRequest>> fetchLeaveRequestRecord({
    required List<User> users,
    required String leaveType,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  }) async {
    if (users.isEmpty || leaveType.isEmpty) {
      throw APIErrorResponse(
        message: 'These fields cannot be empty',
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
        final LeavesRequestsParseObject leavesRequestsParseObject =
            LeavesRequestsParseObject();

        final QueryBuilder<LeavesRequestsParseObject> queryUserLeaveRequest =
            QueryBuilder<LeavesRequestsParseObject>(leavesRequestsParseObject);

        if (today != null) {
          final DateTime startDate =
              DateTime(today.year, today.month, today.day);
          final DateTime endDate =
              DateTime(today.year, today.month, today.day, 23, 59, 59);

          queryUserLeaveRequest
            ..whereGreaterThanOrEqualsTo(
              LeavesRequestsParseObject.keyLeaveDateFrom,
              epochFromDateTime(
                date: startDate,
              ),
            )
            ..whereLessThanOrEqualTo(
              LeavesRequestsParseObject.keyLeaveDateFrom,
              epochFromDateTime(
                date: endDate,
              ),
            );
        } else if (from != null && to != null) {
          queryUserLeaveRequest
            ..whereGreaterThanOrEqualsTo(
              LeavesRequestsParseObject.keyLeaveDateFrom,
              epochFromDateTime(date: from),
            )
            ..whereLessThanOrEqualTo(
              LeavesRequestsParseObject.keyLeaveDateFrom,
              epochFromDateTime(date: to),
            );
        }

        final List<UserLeaveRequest> userLeaveRequest = <UserLeaveRequest>[];

        for (final User userRecord in users) {
          final String userId = userRecord.userId;

          queryUserLeaveRequest
            ..whereEqualTo(
              LeavesRequestsParseObject.keyUser,
              ParseUser.forQuery()..objectId = userId,
            )
            ..whereEqualTo(LeavesRequestsParseObject.keyLeaveType, leaveType);

          final ParseResponse queryLeaveRequestResponse =
              await queryUserLeaveRequest.query();

          if (queryLeaveRequestResponse.error != null) {
            formatAPIErrorResponse(error: queryLeaveRequestResponse.error!);
          }
          final List<LeaveRequest> leaveRequest = <LeaveRequest>[];

          if (queryLeaveRequestResponse.success &&
              queryLeaveRequestResponse.count > 0) {
            final List<LeavesRequestsParseObject> allLeaveRequestCasted =
                List<LeavesRequestsParseObject>.from(
              queryLeaveRequestResponse.results ?? <dynamic>[],
            );

            for (final LeavesRequestsParseObject leaveReq
                in allLeaveRequestCasted) {
              leaveRequest.add(
                LeaveRequest(
                  dateFiledEpoch: leaveReq.dateFiled,
                  dateFromEpoch: leaveReq.leaveDateFrom,
                  dateToEpoch: leaveReq.leaveDateTo,
                  dateUsedEpoch: leaveReq.dateUsed ?? 0,
                  id: leaveReq.objectId!,
                  leaveId: leaveReq.leave.objectId!,
                  leaveType: leaveReq.leaveType,
                  reason: leaveReq.reason,
                  status: leaveReq.status,
                  userId: leaveReq.user.objectId!,
                  declineReason: leaveReq.declineReason,
                ),
              );
            }
          }

          userLeaveRequest.add(
            UserLeaveRequest(
              userId: userId,
              userName: '${userRecord.firstName} ${userRecord.lastName}',
              position: userRecord.position,
              leaveRequest: leaveRequest,
            ),
          );
        }

        return APIListResponse<UserLeaveRequest>(
          success: true,
          message: "Successfully fetch user's record",
          data: userLeaveRequest,
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
