import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepository}) : super(const LoginState());

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
      final APIResponse<dynamic> error = e as APIResponse<dynamic>;
      emit(
        LoginFailed(errorCode: error.errorCode ?? '', message: error.message),
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

      final AuthRegisterRequest payload = AuthRegisterRequest(
        email: email,
        password: password,
        position: position,
        photo: photo,
      );

      // final ParseResponse response = await authRepository.signUpUser(payload);

      // if (response.success) {
      //   emit(const LoginSuccess());
      // }
    } catch (e) {
      print(e);
      // emit(LoginFailed(error.code, error.message, error.formattedError));
    }
  }
}
