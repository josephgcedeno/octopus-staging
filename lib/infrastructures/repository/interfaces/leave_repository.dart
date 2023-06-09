import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

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
  Future<APIResponse<Leave>> createLeave({
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
  Future<APIListResponse<Leave>> getAllLeaves({
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
  Future<APIResponse<Leave>> updateLeave({
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
  Future<APIResponse<void>> deleteLeave({
    required String id,
  });

  /// This function enables to the user to request a leave.
  ///
  /// [dateUsed] this identifies when will this request be used.
  ///
  /// [reason] this identifies what is the reason for the leave.
  ///
  /// [leaveType] this identifies what is the type for this leave. (SICK LEAVE, VACATION LEAVE, EMERGENCY LEAVE)
  ///
  /// [from] this identifies start date of leave request.
  ///
  /// [to] this identifies end date of leave request.
  Future<APIResponse<LeaveRequest>> requestLeave({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
    required DateTime from,
    required DateTime to,
  });

  /// This function will get the list of request leaves.
  ///
  /// [leaveRequestId] this identifies which certain record will be retrieved.
  ///
  /// [leaveId] this will retrieve all record from a certain fiscal year.
  ///
  /// [userId] this will retrieve all record from a certain user.
  ///
  /// [status] this will retrieve all record that matches the status. (STATUS, PENDING, DECLINED, APPROVED).
  Future<APIListResponse<LeaveRequest>> getRequestLeaves({
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
  Future<APIResponse<LeaveRequest>> approveRequestLeave({
    required String requestId,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will declined a certain leave request.
  ///
  /// [requestId] this identifies which request record will be declined.
  ///
  /// [declineReason] this identifies what is the reason for declining the request.
  Future<APIResponse<LeaveRequest>> declineRequestLeave({
    required String requestId,
    required String declineReason,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will cancel a certain leave request.
  ///
  /// [requestId] this identifies which request record will be canceled.
  Future<APIResponse<LeaveRequest>> cancelRequestLeave({
    required String requestId,
  });

  /// This function will get the leave number of the user base from the fiscal year leave.
  ///
  /// [userId] this identifies which user we will be getting no leave.
  ///
  /// [leaveId] this identifies which leave record will be referenced.
  Future<APIResponse<LeaveRemaining>> getRemainingLeaves({
    required String userId,
    String? leaveId,
  });

  Future<APIListResponse<LeaveRequest>> getAllLeaveRequestForToday();

  /// Fetches leave request records from the API based on specified filters.
  ///
  /// [users] list of [User] objects representing the users for whom leave request records should be fetched.
  ///
  /// [leaveType] string representing the type of leave for which records should be fetched.
  ///
  /// [today] representing the specific date for which leave request records should be fetched.
  ///
  /// [from] representing the start date of the date range for which leave request records should be fetched.
  ///
  /// [to] representing the end date of the date range for which leave request records should be fetched.
  Future<APIListResponse<UserLeaveRequest>> fetchLeaveRequestRecord({
    required List<User> users,
    required String leaveType,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  });
}
