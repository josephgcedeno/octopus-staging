import 'package:bloc/bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';

part 'admin_registration_state.dart';

class AdminRegistrationCubit extends Cubit<AdminRegistrationState> {
  AdminRegistrationCubit({required this.iUserRepository})
      : super(const AdminRegistrationState());
  final IUserRepository iUserRepository;

  Future<void> fetchAllUsers() async {
    try {
      emit(FetchAllUsersLoading());
      final APIListResponse<User> response =
          await iUserRepository.fetchAllUser();

      emit(FetchAllUsersSuccess(response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        DeactivateUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        CreateUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        DeactivateUserFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
