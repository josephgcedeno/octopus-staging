class LeaveResponse {
  final String status;
  final List<Leave> leaves;

  LeaveResponse({
    required this.status,
    required this.leaves,
  });
}

class Leave {
  final String id;
  final int noLeaves;
  final int startDateEpoch;
  final int endDateEpoch;

  Leave({
    required this.id,
    required this.noLeaves,
    required this.startDateEpoch,
    required this.endDateEpoch,
  });
}

class LeaveRequestsResponse {
  final String status;
  final List<LeaveRequest> leaveRequests;

  LeaveRequestsResponse({
    required this.status,
    required this.leaveRequests,
  });
}

class LeaveRequest {
  final String id;
  final String leaveId;
  final String userId;
  final int dateFiledEpoch;
  final int dateUsedEpoch;
  final String status;
  final String reason;
  final String leaveType;

  LeaveRequest({
    required this.id,
    required this.leaveId,
    required this.userId,
    required this.dateFiledEpoch,
    required this.dateUsedEpoch,
    required this.status,
    required this.reason,
    required this.leaveType,
  });
}
