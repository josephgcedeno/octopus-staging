part of 'admin_registration_cubit.dart';

class AdminRegistrationState {
  const AdminRegistrationState();
}

class FetchAllUsersLoading extends AdminRegistrationState {
  FetchAllUsersLoading();
}

class FetchAllUsersSuccess extends AdminRegistrationState {
  FetchAllUsersSuccess(this.userList);
  final List<User> userList;
}

class FetchAllUsersFailed extends AdminRegistrationState {
  FetchAllUsersFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}

class CreateUserLoading extends AdminRegistrationState {
  CreateUserLoading();
}

class CreateUserSuccess extends AdminRegistrationState {
  CreateUserSuccess(this.response);
  final APIResponse<User> response;
}

class CreateUserFailed extends AdminRegistrationState {
  CreateUserFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}

class UpdateUserStatusLoading extends AdminRegistrationState {
  UpdateUserStatusLoading({required this.id});
  final String id;
}

class UpdateUserStatusSuccess extends AdminRegistrationState {
  UpdateUserStatusSuccess(this.response, this.userStatus, this.position);
  final APIResponse<User> response;
  final UserStatus userStatus;
  int? position;
}

class UpdateUserStatusFailed extends AdminRegistrationState {
  UpdateUserStatusFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}
