part of 'user_cubit.dart';

class UserState {
  const UserState({this.currentUserRole});
  final UserRole? currentUserRole;
}

class UserInitial extends UserState {}

class FetchCurrentUserLoading extends UserState {}

class FetchCurrentUserSuccess extends UserState {
  FetchCurrentUserSuccess({
    required this.userRole,
  }) : super(currentUserRole: userRole.userRole);

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
