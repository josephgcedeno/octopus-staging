import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';

abstract class ILeaveRepository {
  /// FOR: ADMIN USE ONLY
  ///
  /// This function will create a leave for a certain fiscal year.
  ///
  /// [noLeaves] this identifies what is the number of leaves available for a fiscal year.
  ///
  /// [startDate] this identifies when is the start date for this record.
  ///
  /// [endDate] this identifies when is the start date for this record.
  Future<LeaveResponse> createLeave({
    required int noLeaves,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the created leaves.
  ///
  /// [startDate] this identifies which start year record will be retrieved.
  ///
  /// [endDate] this identifies which end year record will be retrieved.
  Future<LeaveResponse> getAllLeaves({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will update a certain record from the leaves.
  ///
  /// [id] this identifies which record will be updated.
  ///
  /// [noLeaves] this identifies what is the number of leaves available for a fiscal year.
  ///
  /// [startDate] this identifies when is the start date for this record.
  ///
  /// [endDate] this identifies when is the start date for this record.
  Future<LeaveResponse> updateLeave({
    required String id,
    int? noLeaves,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will delete a certain record from the leaves.
  ///
  /// [id] this identifies which record will be updated.
  Future<LeaveResponse> deleteLeave({
    required String id,
  });

  /// This function enables to the user to request a leave.
  ///
  /// [dateUsed] this identifies when will this request be used.
  ///
  /// [reason] this identifies what is the reason for the leave.
  ///
  /// [leaveType] this identifies what is the type for this leave. (SICK LEAVE, VACATION LEAVE, EMERGENCY LEAVE)
  Future<LeaveRequestsResponse> requestLeave({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get the list of request leaves.
  ///
  /// [leaveRequestId] this identifies which certain record will be retrieved.
  ///
  /// [leaveId] this will retrieve all record from a certain fiscal year.
  ///
  /// [userId] this will retrieve all record from a certain user.
  ///
  /// [status] this will retrieve all record that matches the status. (STATUS, PENDING, DECLINED, APPROVED).
  Future<LeaveRequestsResponse> getRequestLeaves({
    String? leaveRequestId,
    String? leaveId,
    String? userId,
    String status = 'PENDING',
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will approve a certain leave request.
  ///
  /// [requestId] this identifies which request record will be approved.
  Future<LeaveRequestsResponse> approveRequestLeave({
    required String requestId,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will declined a certain leave request.
  ///
  /// [requestId] this identifies which request record will be declined.
  Future<LeaveRequestsResponse> declineRequestLeave({
    required String requestId,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will cancel a certain leave request.
  ///
  /// [requestId] this identifies which request record will be canceled.
  Future<LeaveRequestsResponse> cancelRequestLeave({
    required String requestId,
  });
}
