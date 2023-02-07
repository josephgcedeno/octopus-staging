import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';

abstract class ILeaveRepository {
  Future<LeaveResponse> createLeave({
    required int noLeaves,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<LeaveResponse> getAllLeaves({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<LeaveResponse> updateLeave({
    required String id,
    int? noLeaves,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<LeaveResponse> deleteLeave({
    required String id,
  });

  Future<LeaveRequestsResponse> requestLeave({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
  });

  Future<LeaveRequestsResponse> getRequestLeaves({
    String? leaveRequestId,
    String? leaveId,
    String? userId,
    String status = 'PENDING',
  });

  Future<LeaveRequestsResponse> approveRequestLeave({
    required String requestId,
  });

  Future<LeaveRequestsResponse> declineRequestLeave({
    required String requestId,
  });

  Future<LeaveRequestsResponse> cancelRequestLeave({
    required String requestId,
  });
}
