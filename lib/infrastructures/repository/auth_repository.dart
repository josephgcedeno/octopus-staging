import 'package:octopus/infrastructures/models/api_response.dart';
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

      if (sessionResponse != null && sessionResponse.success) {
        return (sessionResponse.error?.type ?? '') != 'InvalidSessionToken';
      }

      throw APIResponse<void>(
        success: false,
        message: sessionResponse != null && sessionResponse.error != null
            ? sessionResponse.error!.message
            : '',
        data: null,
        errorCode: sessionResponse?.error != null
            ? sessionResponse?.error.toString()
            : '',
      );
    } else if (user == null) {
      return false;
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<ParseResponse> loginUser(AuthLoginRequest payload) async {
    final ParseUser user = ParseUser(
      payload.username,
      payload.password,
      payload.username,
    );

    final ParseResponse loginAccountResponse = await user.login();
    if (loginAccountResponse.success) {
      return loginAccountResponse;
    }

    throw APIResponse<void>(
      success: false,
      message: loginAccountResponse.error != null
          ? loginAccountResponse.error!.message
          : '',
      data: null,
      errorCode: loginAccountResponse.error != null
          ? loginAccountResponse.error.toString()
          : '',
    );
  }

  @override
  Future<ParseResponse> resetPassword({
    required String email,
  }) async {
    final ParseResponse resetResponse =
        await ParseUser(null, null, email).requestPasswordReset();
    if (resetResponse.success) {
      return resetResponse;
    }

    throw APIResponse<void>(
      success: false,
      message: resetResponse.error != null ? resetResponse.error!.message : '',
      data: null,
      errorCode:
          resetResponse.error != null ? resetResponse.error.toString() : '',
    );
  }

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

    final ParseResponse signUpResponse = await user.signUp();
    if (signUpResponse.success) {
      return signUpResponse;
    }
    throw APIResponse<void>(
      success: false,
      message:
          signUpResponse.error != null ? signUpResponse.error!.message : '',
      data: null,
      errorCode:
          signUpResponse.error != null ? signUpResponse.error.toString() : '',
    );
  }

  @override
  Future<ParseResponse> logout() async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null) {
      final ParseResponse logoutResponse = await user.logout();

      if (logoutResponse.success) {
        return logoutResponse;
      }
      throw APIResponse<void>(
        success: false,
        message:
            logoutResponse.error != null ? logoutResponse.error!.message : '',
        data: null,
        errorCode:
            logoutResponse.error != null ? logoutResponse.error.toString() : '',
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }
}
