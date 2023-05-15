import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';

part 'historical_state.dart';

class HistoricalCubit extends Cubit<HistoricalState> {
  HistoricalCubit({
    required this.userRepository,
  }) : super(HistoricalInitial());

  final IUserRepository userRepository;

  Future<void> fetchAllUser() async {
    try {
      emit(FetchAllUserLoading());

      final APIListResponse<User> response =
          await userRepository.fetchAllUser();

      emit(FetchAllUserSuccess(users: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchAllUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  void toggleUser(User user) {
    if (state.selectedUser?.contains(user) ?? false) {
      emit(
        HistoricalState(
          selectedUser: List<User>.of(state.selectedUser ?? <User>[])
            ..remove(user),
        ),
      );
    } else {
      emit(
        HistoricalState(
          selectedUser: List<User>.of(state.selectedUser ?? <User>[])
            ..add(user),
        ),
      );
    }
  }
}
