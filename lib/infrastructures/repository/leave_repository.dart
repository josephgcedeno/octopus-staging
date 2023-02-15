import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/leave_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LeaveRepository extends ILeaveRepository {
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
        final ParseObject leaves = ParseObject(leavesTable)
          ..set<int>(leavesNoLeavesField, noLeaves)
          ..set<int>(leavesStartDateField, startDateEpoch)
          ..set<int>(leavesEndDateField, endDateEpoch);
        final ParseResponse createLeaveResponse = await leaves.save();

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

        throw APIErrorResponse(
          message: createLeaveResponse.error != null
              ? createLeaveResponse.error!.message
              : '',
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
  Future<APIListResponse<Leave>> getAllLeaves({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaves = ParseObject(leavesTable);
        final QueryBuilder<ParseObject> leavesQuery =
            QueryBuilder<ParseObject>(leaves);

        if (startDate != null && endDate != null) {
          leavesQuery
            ..whereGreaterThanOrEqualsTo(
              leavesStartDateField,
              epochFromDateTime(date: startDate),
            )
            ..whereLessThan(
              leavesEndDateField,
              epochFromDateTime(date: endDate),
            );
        }

        final ParseResponse getAllLeaveResponse =
            startDate != null && endDate != null
                ? await leavesQuery.query()
                : await leaves.getAll();

        if (getAllLeaveResponse.success) {
          final List<Leave> leaves = <Leave>[];

          if (getAllLeaveResponse.results != null) {
            for (final ParseObject leave
                in getAllLeaveResponse.results! as List<ParseObject>) {
              leaves.add(
                Leave(
                  id: leave.objectId!,
                  startDateEpoch: leave.get<int>(leavesStartDateField)!,
                  endDateEpoch: leave.get<int>(leavesEndDateField)!,
                  noLeaves: leave.get<int>(leavesNoLeavesField)!,
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

        throw APIErrorResponse(
          message: getAllLeaveResponse.error != null
              ? getAllLeaveResponse.error!.message
              : '',
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
  Future<APIResponse<Leave>> updateLeave({
    required String id,
    int? noLeaves,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (id.isEmpty) {
      throw APIErrorResponse(
        message: 'ID is required to update leave.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaves = ParseObject(leavesTable);

        leaves.objectId = id;

        if (noLeaves != null) {
          leaves.set<int>(leavesNoLeavesField, noLeaves);
        }
        if (startDate != null && endDate != null) {
          leaves
            ..set<int>(leavesStartDateField, epochFromDateTime(date: startDate))
            ..set<int>(leavesEndDateField, epochFromDateTime(date: endDate));
        }
        final ParseResponse updateVacationResponse = await leaves.save();

        if (updateVacationResponse.success) {
          final ParseResponse getVacationInfoResponse =
              await leaves.getObject(id);

          if (getVacationInfoResponse.success &&
              getVacationInfoResponse.results != null) {
            final ParseObject resultParseObject =
                getParseObject(getVacationInfoResponse.results!);

            return APIResponse<Leave>(
              success: true,
              message: 'Successfull updated leave',
              data: Leave(
                id: id,
                noLeaves: resultParseObject.get<int>(leavesNoLeavesField)!,
                startDateEpoch:
                    resultParseObject.get<int>(leavesStartDateField)!,
                endDateEpoch: resultParseObject.get<int>(leavesEndDateField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateVacationResponse.error != null
              ? updateVacationResponse.error!.message
              : '',
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
  Future<APIResponse<void>> deleteLeave({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaves = ParseObject(leavesTable);

        final ParseResponse deleteVacationResponse =
            await leaves.delete(id: id);

        if (deleteVacationResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted leave.',
            data: null,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: deleteVacationResponse.error != null
              ? deleteVacationResponse.error!.message
              : '',
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
  Future<APIResponse<LeaveRequest>> approveRequestLeave({
    required String requestId,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaveRequests = ParseObject(leaveRequestsTable);

        leaveRequests
          ..objectId = requestId
          ..set<String>(leaveRequestStatusField, 'APPROVED');

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final ParseObject leaveReq =
                getParseObject(getUpdatedRecordResponse.results!);

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully approved leave request.',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.get<String>(leaveRequestLeaveIdField)!,
                userId: leaveReq.get<String>(leaveRequestUserIdField)!,
                dateFiledEpoch: leaveReq.get<int>(leaveRequestDateFiledField)!,
                dateUsedEpoch: leaveReq.get<int>(leaveRequestDateUsedField)!,
                leaveType: leaveReq.get<String>(leaveRequestLeaveTypeField)!,
                reason: leaveReq.get<String>(leaveRequestReasonField)!,
                status: leaveReq.get<String>(leaveRequestStatusField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateReqRecordResponse.error != null
              ? updateReqRecordResponse.error!.message
              : '',
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
  Future<APIResponse<LeaveRequest>> cancelRequestLeave({
    required String requestId,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaveRequests = ParseObject(leaveRequestsTable);

        leaveRequests
          ..objectId = requestId
          ..set<String>(leaveRequestStatusField, 'CANCELLED');

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final ParseObject leaveReq =
                getParseObject(getUpdatedRecordResponse.results!);

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully canceled leave request',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.get<String>(leaveRequestLeaveIdField)!,
                userId: leaveReq.get<String>(leaveRequestUserIdField)!,
                dateFiledEpoch: leaveReq.get<int>(leaveRequestDateFiledField)!,
                dateUsedEpoch: leaveReq.get<int>(leaveRequestDateUsedField)!,
                leaveType: leaveReq.get<String>(leaveRequestLeaveTypeField)!,
                reason: leaveReq.get<String>(leaveRequestReasonField)!,
                status: leaveReq.get<String>(leaveRequestStatusField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateReqRecordResponse.error != null
              ? updateReqRecordResponse.error!.message
              : '',
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
  Future<APIResponse<LeaveRequest>> declineRequestLeave({
    required String requestId,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaveRequests = ParseObject(leaveRequestsTable);

        leaveRequests
          ..objectId = requestId
          ..set<String>(leaveRequestStatusField, 'DECLINED');

        final ParseResponse updateReqRecordResponse =
            await leaveRequests.save();

        if (updateReqRecordResponse.success) {
          final ParseResponse getUpdatedRecordResponse =
              await leaveRequests.getObject(requestId);

          if (getUpdatedRecordResponse.success) {
            final ParseObject leaveReq =
                getParseObject(getUpdatedRecordResponse.results!);

            return APIResponse<LeaveRequest>(
              success: true,
              message: 'Successfully declined leave request.',
              data: LeaveRequest(
                id: leaveReq.objectId!,
                leaveId: leaveReq.get<String>(leaveRequestLeaveIdField)!,
                userId: leaveReq.get<String>(leaveRequestUserIdField)!,
                dateFiledEpoch: leaveReq.get<int>(leaveRequestDateFiledField)!,
                dateUsedEpoch: leaveReq.get<int>(leaveRequestDateUsedField)!,
                leaveType: leaveReq.get<String>(leaveRequestLeaveTypeField)!,
                reason: leaveReq.get<String>(leaveRequestReasonField)!,
                status: leaveReq.get<String>(leaveRequestStatusField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateReqRecordResponse.error != null
              ? updateReqRecordResponse.error!.message
              : '',
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
  Future<APIListResponse<LeaveRequest>> getRequestLeaves({
    String? leaveRequestId,
    String? leaveId,
    String? userId,
    String status = 'PENDING',
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject leaveRequests = ParseObject(leaveRequestsTable);

        final QueryBuilder<ParseObject> leaveReqQuery =
            QueryBuilder<ParseObject>(leaveRequests)
              ..whereEqualTo(leaveRequestStatusField, status);

        if (leaveId != null) {
          leaveReqQuery.whereEqualTo(leaveRequestLeaveIdField, leaveId);
        }
        if (userId != null) {
          leaveReqQuery.whereEqualTo(leaveRequestUserIdField, userId);
        }

        final ParseResponse getLeaveReqResponse = leaveRequestId != null
            ? await leaveRequests.getObject(leaveRequestId)
            : await leaveReqQuery.query();

        if (getLeaveReqResponse.success) {
          final List<LeaveRequest> leaveRequests = <LeaveRequest>[];

          if (getLeaveReqResponse.results != null) {
            for (final ParseObject leaveRequest
                in getLeaveReqResponse.results! as List<ParseObject>) {
              leaveRequests.add(
                LeaveRequest(
                  id: leaveRequest.objectId!,
                  leaveId: leaveRequest.get<String>(leaveRequestLeaveIdField)!,
                  userId: leaveRequest.get<String>(leaveRequestUserIdField)!,
                  dateFiledEpoch:
                      leaveRequest.get<int>(leaveRequestDateFiledField)!,
                  dateUsedEpoch:
                      leaveRequest.get<int>(leaveRequestDateUsedField)!,
                  status: leaveRequest.get<String>(leaveRequestStatusField)!,
                  leaveType:
                      leaveRequest.get<String>(leaveRequestLeaveTypeField)!,
                  reason: leaveRequest.get<String>(leaveRequestReasonField)!,
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
          message: getLeaveReqResponse.error != null
              ? getLeaveReqResponse.error!.message
              : '',
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

  Future<ParseObject> getCurrentYearInfo() async {
    /// Get the current date and query if under in the
    final DateTime datetToQuery =
        DateTime(currentDay.year, currentDay.month, currentDay.day);

    final int dateToQueryEpoch = epochFromDateTime(date: datetToQuery);

    final ParseObject leaves = ParseObject(leavesTable);

    final QueryBuilder<ParseObject> queryRecordThisYear =
        QueryBuilder<ParseObject>(leaves)
          ..whereGreaterThanOrEqualsTo(
            leavesEndDateField,
            dateToQueryEpoch,
          )
          ..whereLessThanOrEqualTo(
            leavesStartDateField,
            dateToQueryEpoch,
          );
    final ParseResponse data = await queryRecordThisYear.query();

    if (data.success && data.results != null) {
      return data.results!.first as ParseObject;
    }

    throw 'No record from this day that match the year range';
  }

  @override
  Future<APIResponse<LeaveRequest>> requestLeave({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final ParseObject leaveRequests = ParseObject(leaveRequestsTable);

        final String currentYearsId = await getCurrentYearInfo().then(
          (ParseObject value) => value.objectId!,
        );
        final String usersId = user.objectId!;
        final int dateFiledEpoch = epochFromDateTime(
          date: DateTime(currentDay.year, currentDay.month, currentDay.day),
        );

        final int dateUsedEpoch = epochFromDateTime(date: dateUsed);

        const String status = 'PENDING';

        leaveRequests
          ..set<String>(leaveRequestLeaveIdField, currentYearsId)
          ..set<String>(leaveRequestUserIdField, usersId)
          ..set<int>(leaveRequestDateFiledField, dateFiledEpoch)
          ..set<int>(leaveRequestDateUsedField, dateUsedEpoch)
          ..set<String>(leaveRequestStatusField, status)
          ..set<String>(leaveRequestReasonField, reason)
          ..set<String>(leaveRequestLeaveTypeField, leaveType);

        final ParseResponse createLeaveRequestResponse =
            await leaveRequests.save();
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
            ),
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: createLeaveRequestResponse.error != null
              ? createLeaveRequestResponse.error!.message
              : '',
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
}
