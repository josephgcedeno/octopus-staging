import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class IAuthRepository {
  /// This function will be use to login user.
  ///
  /// [username] username provided to the account to authenticate.
  ///
  /// [password] password provided to the account to authenticate.
  ///
  /// [email] email provided to the account to authenticate. It is nullable since username and password would be enough for authenticating.
  Future<ParseResponse> loginUser({
    required String username,
    required String password,
    String? email,
  });

  /// This function will be use to register user account.
  ///
  /// [email] email that is associated to this account.
  ///
  /// [password] password that is associated to this account.
  ///
  /// [name] the user's fullname and not necessarily required for signing up, it's a extra field for user table.
  ///
  /// [position] the user's current position in the company and not necessarily required for signing up, it's a extra field for user table.
  Future<ParseResponse> signUpUser({
    required String email,
    required String password,
    String? name,
    String? position,
    bool? isAdmin,
    String? photo,
  });

  /// This function will be use in the future for resetting the password.
  ///
  /// [email] this is where the recovery mail will be sent and create a new password.
  Future<ParseResponse> resetPassword({
    required String email,
  });

  /// This function will validate if the user is already logged in. It will verify if the token is expired or not. If expired, the user will need to login again.
  Future<bool> isLoggedIn();
}
