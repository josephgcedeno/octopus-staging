part of 'authentication_cubit.dart';

class AuthenticationState {
  const AuthenticationState();
}

class LoginSuccess extends AuthenticationState {
  const LoginSuccess();
}

class LoginFailed extends AuthenticationState {
  const LoginFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class LoginLoading extends AuthenticationState {
  const LoginLoading();
}

class ValidateTokenSuccess extends AuthenticationState {
  const ValidateTokenSuccess();
}

class ValidateTokenFailed extends AuthenticationState {
  const ValidateTokenFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
