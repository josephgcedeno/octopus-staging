import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.authRepository})
      : super(const AuthenticationState());

  final IAuthRepository authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(const LoginLoading());

      final AuthLoginRequest payload =
          AuthLoginRequest(username: email, password: password);

      await authRepository.loginUser(payload);
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
