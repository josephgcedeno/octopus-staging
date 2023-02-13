import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuthRepository extends IAuthRepository {
  @override
  Future<APIResponse<void>> isLoggedIn() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        /// Get the current session token of the user.
        final String sessionToken = user.sessionToken!;

        /// Use this function to validate if the current sessionToken is valid.
        final ParseResponse? sessionResponse =
            await ParseUser.getCurrentUserFromServer(sessionToken);

        if (sessionResponse != null && sessionResponse.success) {
          return APIResponse<void>(
            success: sessionResponse.success,
            message: 'User already logged in.',
            errorCode: null,
            data: null,
          );
        }

        throw APIErrorResponse(
          message: sessionResponse != null && sessionResponse.error != null
              ? sessionResponse.error!.message
              : '',
          errorCode: sessionResponse?.error != null
              ? sessionResponse?.error.toString()
              : '',
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> loginUser(AuthLoginRequest payload) async {
    try {
      final ParseUser user = ParseUser(
        payload.username,
        payload.password,
        payload.username,
      );

      final ParseResponse loginAccountResponse = await user.login();
      if (loginAccountResponse.success) {
        return APIResponse<void>(
          success: true,
          message: 'Login successfully.',
          errorCode: null,
          data: null,
        );
      }

      throw APIErrorResponse(
        message: loginAccountResponse.error != null
            ? loginAccountResponse.error!.message
            : '',
        errorCode: loginAccountResponse.error != null
            ? loginAccountResponse.error.toString()
            : '',
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> resetPassword({
    required String email,
  }) async {
    try {
      final ParseResponse resetResponse =
          await ParseUser(null, null, email).requestPasswordReset();

      if (resetResponse.success) {
        return APIResponse<void>(
          success: resetResponse.success,
          message: 'Successfully sent reset link to the email!',
          data: null,
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message:
            resetResponse.error != null ? resetResponse.error!.message : '',
        errorCode:
            resetResponse.error != null ? resetResponse.error.toString() : '',
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> signUpUser(AuthRegisterRequest payload) async {
    try {
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
        return APIResponse<void>(
          success: true,
          message: 'Successfully registered.',
          errorCode: null,
          data: null,
        );
      }
      throw APIErrorResponse(
        message:
            signUpResponse.error != null ? signUpResponse.error!.message : '',
        errorCode:
            signUpResponse.error != null ? signUpResponse.error.toString() : '',
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> logout() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        final ParseResponse logoutResponse = await user.logout();

        if (logoutResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully logged out.',
            errorCode: null,
            data: null,
          );
        }
        throw APIErrorResponse(
          message:
              logoutResponse.error != null ? logoutResponse.error!.message : '',
          errorCode: logoutResponse.error != null
              ? logoutResponse.error.toString()
              : '',
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }
}
