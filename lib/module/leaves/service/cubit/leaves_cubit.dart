import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/leave_repository.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_status.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  LeavesCubit({required this.leaveRepository}) : super(LeavesState());
  final ILeaveRepository leaveRepository;

  Future<void> fetchAllLeaves() async {
    try {
      emit(FetchAllLeavesDataLoading());

      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        final String userId = user.objectId!;
        final APIResponse<LeaveRemaining> response =
            await leaveRepository.getRemainingLeaves(userId: userId);
        emit(
          FetchAllLeavesDataSuccess(leaveRemaining: response.data),
        );
      }
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchAllLeavesDataFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  Future<void> submitLeaveRequest({
    required DateTime dateUsed,
    required String reason,
    required String leaveType,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      emit(SubmitLeaveRequestLoading());
      final APIResponse<LeaveRequest> response =
          await leaveRepository.requestLeave(
        dateUsed: dateUsed,
        reason: reason,
        leaveType: leaveType,
        from: from,
        to: to,
      );
      emit(SubmitLeaveRequestSuccess(leaveRequest: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchAllLeavesDataFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
