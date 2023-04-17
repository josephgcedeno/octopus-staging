part of 'leaves_cubit.dart';

class LeavesState {
  LeavesState();
}

class FetchAllLeavesDataLoading extends LeavesState {
  FetchAllLeavesDataLoading();
}

class FetchAllLeavesDataSuccess extends LeavesState {
  FetchAllLeavesDataSuccess({required this.leaveCount});

  final LeaveRemaining? leaveCount;
}

class FetchAllLeavesDataFailed extends LeavesState {
  FetchAllLeavesDataFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}

class SubmitLeaveRequestLoading extends LeavesState {
  SubmitLeaveRequestLoading();
}

class SubmitLeaveRequestSuccess extends LeavesState {
  SubmitLeaveRequestSuccess({required this.leaveRequest});
  final LeaveRequest leaveRequest;
}

class SubmitLeavesRequestFailed extends LeavesState {
  SubmitLeavesRequestFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}
