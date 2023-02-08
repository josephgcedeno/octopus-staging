import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

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
      // final PlayerLoginRequestResponse response =

      final ParseResponse x = await authRepository.loginUser(payload);
      log(jsonEncode(x.success));

      emit(const LoginSuccess());
    } catch (e) {
      print(e);
      // APIErrorResponse error = APIErrorResponse(code: '', message: '');
      // Map<String, dynamic> errorBody = <String, dynamic>{};

      // if (e is! APIErrorResponse) {
      //   errorBody = e as Map<String, dynamic>;
      //   error = errorBody['response'] as APIErrorResponse;
      // } else {
      //   error = e;
      // }

      // if (error.code == 'UNKNOWN_PLAYER_IP_ADDRESS') {
      //   if (isNewIp == true) {
      //     emit(
      //       LoginWithNewIPResend(
      //         error.message,
      //         errorBody['player_id'].toString(),
      //         errorBody['from_ip'].toString(),
      //       ),
      //     );
      //   } else {
      //     emit(
      //       LoginWithNewIP(
      //         error.message,
      //         errorBody['player_id'].toString(),
      //         errorBody['from_ip'].toString(),
      //       ),
      //     );
      //   }
      // }

      // emit(LoginFailed(error.code, error.message, error.formattedError));
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

      final ParseResponse response = await authRepository.signUpUser(payload);

      if (response.success) {
        emit(const LoginSuccess());
      }
    } catch (e) {
      print(e);
      // emit(LoginFailed(error.code, error.message, error.formattedError));
    }
  }
}
