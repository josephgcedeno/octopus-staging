/// This object will contain the necessary field for Leave record.
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

/// This object will contain the necessary field for LeaveRequest record.
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
    required this.dateFromEpoch,
    required this.dateToEpoch,
    this.userName,
    this.declineReason,
  });

  final String id;
  final String leaveId;
  final String userId;
  final int dateFiledEpoch;
  final int dateUsedEpoch;
  final String status;
  final String reason;
  final String leaveType;
  final int dateFromEpoch;
  final int dateToEpoch;
  final String? declineReason;
  String? userName;
}

class LeaveRemaining {
  LeaveRemaining({
    required this.leaveId,
    required this.remainingLeave,
    required this.consumedLeave,
  });

  final String leaveId;
  final int remainingLeave;
  final int consumedLeave;
}

class UserLeaveRequest {
  UserLeaveRequest({
    required this.userId,
    required this.userName,
    required this.position,
    required this.leaveRequest,
  });

  final String userId;
  final String userName;
  final String position;
  final List<LeaveRequest> leaveRequest;
}
