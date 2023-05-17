import 'package:json_annotation/json_annotation.dart';

part 'leaves_response.g.dart';

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
@JsonSerializable()
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

  factory LeaveRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$LeaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveRequestToJson(this);

  final String id;
  @JsonKey(name: 'leave_id')
  final String leaveId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'date_filed_epoch')
  final int dateFiledEpoch;
  @JsonKey(name: 'date_used_epoch')
  final int dateUsedEpoch;
  final String status;
  final String reason;
  @JsonKey(name: 'leave_type')
  final String leaveType;
  @JsonKey(name: 'date_from_epoch')
  final int dateFromEpoch;
  @JsonKey(name: 'date_to_epoch')
  final int dateToEpoch;
  @JsonKey(name: 'decline_reason')
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

@JsonSerializable()
class UserLeaveRequest {
  UserLeaveRequest({
    required this.userId,
    required this.userName,
    required this.position,
    required this.leaveRequest,
  });

  factory UserLeaveRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UserLeaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserLeaveRequestToJson(this);

  @JsonKey(name: 'user_id')
  final String userId;
  final String userName;
  final String position;
  @JsonKey(name: 'leave_requests')
  final List<LeaveRequest> leaveRequest;
}
