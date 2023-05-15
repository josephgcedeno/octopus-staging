import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';
import 'package:octopus/infrastructures/repository/interfaces/secure_storage_repository.dart';
import 'package:octopus/internal/local_storage.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required this.authRepository,
    required this.storageRepository,
  }) : super(const AuthenticationState());

  final IAuthRepository authRepository;
  final ISecureStorageRepository storageRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(const LoginLoading());

      final AuthLoginRequest payload =
          AuthLoginRequest(username: email, password: password);

      final APIResponse<User> response =
          await authRepository.loginUser(payload);

      // This will write all the information of the user to local secure storage
      await writeUserInfo(response.data);
      emit(const LoginSuccess());
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        LoginFailed(errorCode: error.errorCode ?? '', message: error.message),
      );
    }
  }

  Future<void> validateToken() async {
    try {
      await authRepository.isLoggedIn();
      emit(const ValidateTokenSuccess());
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        ValidateTokenFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  /// This function will write an info to the local storage of the user after logging in.
  Future<void> writeUserInfo(User user) async {
    await storageRepository.write(key: lsId, value: user.id);
    await storageRepository.write(key: lsFirstName, value: user.firstName);
    await storageRepository.write(key: lsLastName, value: user.lastName);
    await storageRepository.write(key: lsNuxifyId, value: user.nuxifyId);
    await storageRepository.write(
      key: lsBirthDateEpoch,
      value: user.birthDateEpoch.toString(),
    );
    await storageRepository.write(key: lsAddress, value: user.address);
    await storageRepository.write(
      key: lsCivilStatus,
      value: user.civilStatus,
    );
    await storageRepository.write(
      key: lsDateHiredEpoch,
      value: user.dateHiredEpoch.toString(),
    );
    await storageRepository.write(
      key: lsProfileImageSource,
      value: user.profileImageSource,
    );
    await storageRepository.write(
      key: lsIsDeactive,
      value: user.isDeactive.toString(),
    );
    await storageRepository.write(key: lsPosition, value: user.position);
    await storageRepository.write(key: lsPagIbigNo, value: user.pagIbigNo);
    await storageRepository.write(key: lsSssNo, value: user.sssNo);
    await storageRepository.write(key: lsTinNo, value: user.tinNo);
    await storageRepository.write(
      key: lsPhilHealthNo,
      value: user.philHealtNo,
    );
  }

  /// This flush the user info from secure storage after logout.
  Future<void> flushSecureStorage() async {
    await storageRepository.delete(key: lsId);
    await storageRepository.delete(key: lsFirstName);
    await storageRepository.delete(key: lsLastName);
    await storageRepository.delete(key: lsNuxifyId);
    await storageRepository.delete(key: lsBirthDateEpoch);
    await storageRepository.delete(key: lsAddress);
    await storageRepository.delete(key: lsCivilStatus);
    await storageRepository.delete(key: lsDateHiredEpoch);
    await storageRepository.delete(key: lsProfileImageSource);
    await storageRepository.delete(key: lsIsDeactive);
    await storageRepository.delete(key: lsPosition);
    await storageRepository.delete(key: lsPagIbigNo);
    await storageRepository.delete(key: lsSssNo);
    await storageRepository.delete(key: lsTinNo);
    await storageRepository.delete(key: lsPhilHealthNo);
  }

  Future<void> register({
    required String email,
    required String password,
    required String position,
    String? photo,
  }) async {
    try {
      emit(const LoginLoading());

      // final AuthRegisterRequest payload = AuthRegisterRequest(
      //   email: email,
      //   password: password,
      //   position: position,
      //   photo: photo,
      // );

      // final ParseResponse response = await authRepository.signUpUser(payload);

      // if (response.success) {
      //   emit(const LoginSuccess());
      // }
    } catch (e) {
      // print(e);
      // emit(LoginFailed(error.code, error.message, error.formattedError));
    }
  }
}
