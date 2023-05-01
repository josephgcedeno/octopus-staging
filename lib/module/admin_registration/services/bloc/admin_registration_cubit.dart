import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String address,
    required String civilStatus,
    required DateTime dateHired,
    required String profileImageSource,
    required String position,
    required String pagIbigNo,
    required String sssNo,
    required String tinNo,
    required String philHealtNo,
  }) async {
    try {
      emit(CreateUserLoading());
      final APIResponse<User> response = await iUserRepository.createUser(
        id: '1',
        firstName: firstName,
        lastName: lastName,
        nuxifyId: 'nuxifyId',
        birthDate: birthDate,
        address: address,
        civilStatus: civilStatus,
        dateHired: dateHired,
        profileImageSource: profileImageSource,
        position: position,
        pagIbigNo: pagIbigNo,
        sssNo: sssNo,
        tinNo: tinNo,
        philHealtNo: philHealtNo,
      );
      emit(CreateUserSuccess(response));
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

  Future<void> deactivateUser({required String id}) async {
    try {
      emit(DeactivateUserLoading());
      final APIResponse<User> response =
          await iUserRepository.deactivateUser(id: id);

      emit(DeactivateUserSuccess(response));
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
