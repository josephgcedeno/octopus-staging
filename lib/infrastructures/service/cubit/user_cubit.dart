import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.userRepository}) : super(UserInitial());
  final IUserRepository userRepository;

  Future<void> fetchUserRole() async {
    try {
      emit(FetchCurrentUserLoading());

      final APIResponse<UseWithrRole> response =
          await userRepository.fetchCurrentUser();
      emit(FetchCurrentUserSuccess(userRole: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchCurrentUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
