part of 'login_cubit.dart';

class LoginState {
  const LoginState();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginFailed extends LoginState {
  const LoginFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class LoginLoading extends LoginState {
  const LoginLoading();
}
