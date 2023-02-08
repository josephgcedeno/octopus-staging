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
  Future<ParseResponse> loginUser({
    required String username,
    required String password,
    String? email,
  }) async {
    final ParseUser user = ParseUser(
      username,
      password,
      email,
    );

    return user.login();
  }

  @override
  Future<ParseResponse> resetPassword({
    required String email,
  }) async =>
      ParseUser(null, null, email).requestPasswordReset();

  @override
  Future<ParseResponse> signUpUser({
    required String password,
    required String email,
    String? name,
    String? position,
    bool? isAdmin,
    String? photo,
  }) async {
    final ParseUser user = ParseUser.createUser(
      email,
      password,
      email,
    )
      ..set<String?>(usersNameField, name)
      ..set<String?>(usersPositionField, position)
      ..set<bool?>(usersIsAdminField, isAdmin)
      ..set<String?>(usersPhotoField, photo);

    return user.signUp();
  }
}
