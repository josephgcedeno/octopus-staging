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
class DeactivateUserFailed extends AdminRegistrationState {
  DeactivateUserFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}
