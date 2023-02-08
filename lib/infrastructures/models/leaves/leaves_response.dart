class LeaveResponse {
  LeaveResponse({
    required this.status,
    required this.leaves,
  });

  final String status;
  final List<Leave> leaves;
}

class Leave {
  Leave({
    required this.id,
    required this.noLeaves,
    required this.startDateEpoch,
    required this.endDateEpoch,
  });

  final String id;
  final int noLeaves;
  final int startDateEpoch;
  final int endDateEpoch;
}

class LeaveRequestsResponse {
  LeaveRequestsResponse({
    required this.status,
    required this.leaveRequests,
  });

  final String status;
  final List<LeaveRequest> leaveRequests;
}

class LeaveRequest {
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

  final String id;
  final String leaveId;
  final String userId;
  final int dateFiledEpoch;
  final int dateUsedEpoch;
  final String status;
  final String reason;
  final String leaveType;
}
