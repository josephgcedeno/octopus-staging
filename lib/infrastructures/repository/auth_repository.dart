import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuthRepository extends IAuthRepository {
  @override
  Future<bool> isLoggedIn() async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null) {
      /// Get the current session token of the user.
      final String sessionToken = user.sessionToken!;

      /// Use this function to validate if the current sessionToken is valid.
      final ParseResponse? sessionResponse =
          await ParseUser.getCurrentUserFromServer(sessionToken);

      return sessionResponse != null &&
          (sessionResponse.error?.type ?? '') != 'InvalidSessionToken';
    }

    return false;
  }

  @override
  Future<ParseResponse> loginUser(AuthLoginRequest payload) async {
    final ParseUser user = ParseUser(
      payload.username,
      payload.password,
      payload.username,
    );

    return user.login();
  }

  @override
  Future<ParseResponse> resetPassword({
    required String email,
  }) async =>
      ParseUser(null, null, email).requestPasswordReset();

  @override
  Future<ParseResponse> signUpUser(AuthRegisterRequest payload) async {
    final ParseUser user = ParseUser.createUser(
      payload.email,
      payload.password,
      payload.email,
    )
      ..set<String?>(usersNameField, payload.email)
      ..set<String?>(usersPositionField, payload.position)
      ..set<bool?>(usersIsAdminField, payload.isAdmin ?? false)
      ..set<String?>(usersPhotoField, payload.photo);

    return user.signUp();
  }
}
