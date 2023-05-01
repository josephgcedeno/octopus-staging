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

class DeactivateUserLoading extends AdminRegistrationState {
  DeactivateUserLoading();
}

class DeactivateUserSuccess extends AdminRegistrationState {
  DeactivateUserSuccess(this.response);
  final APIResponse<User> response;
}

class DeactivateUserFailed extends AdminRegistrationState {
  DeactivateUserFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}
