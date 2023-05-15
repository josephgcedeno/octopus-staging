part of 'user_cubit.dart';

class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class FetchCurrentUserLoading extends UserState {}

class FetchCurrentUserSuccess extends UserState {
  FetchCurrentUserSuccess({
    required this.userRole,
  });

  final UseWithrRole userRole;
}

class FetchCurrentUserFailed extends UserState {
  FetchCurrentUserFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
