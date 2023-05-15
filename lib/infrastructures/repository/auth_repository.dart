import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/auth/auth_request.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/auth_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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

        /// Check if ParseResponse is error is not null.
        if (sessionResponse?.error != null) {
          formatAPIErrorResponse(error: sessionResponse!.error!);
        }

        if (sessionResponse != null && sessionResponse.success) {
          return APIResponse<void>(
            success: sessionResponse.success,
            message: 'User already logged in.',
            errorCode: null,
            data: null,
          );
        }
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
  Future<APIResponse<User>> loginUser(AuthLoginRequest payload) async {
    try {
      final ParseUser user = ParseUser(
        payload.username,
        payload.password,
        payload.username,
      );

      final ParseResponse loginAccountResponse = await user.login();

      /// Check if ParseResponse is error is not null.
      if (loginAccountResponse.error != null) {
        formatAPIErrorResponse(error: loginAccountResponse.error!);
      }
      if (loginAccountResponse.success) {
        final String id = getResultId(loginAccountResponse.results!);

        final QueryBuilder<EmployeeInfoParseObject> employeeInfoQuery =
            QueryBuilder<EmployeeInfoParseObject>(EmployeeInfoParseObject())
              ..whereEqualTo(
                EmployeeInfoParseObject.keyUser,
                ParseUser.forQuery()..objectId = id,
              )
              ..setLimit(1);

        final ParseResponse employeeInfoResponse =
            await employeeInfoQuery.query();

        /// Check if ParseResponse is error is not null.
        if (employeeInfoResponse.error != null) {
          formatAPIErrorResponse(error: employeeInfoResponse.error!);
        }

        if (employeeInfoResponse.success &&
            employeeInfoResponse.result != null) {
          final EmployeeInfoParseObject result =
              EmployeeInfoParseObject.toCustomParseObject(
            data: employeeInfoResponse.results!.first,
          );

          return APIResponse<User>(
            success: true,
            message: 'Login successfully.',
            errorCode: null,
            data: User(
              address: result.address,
              birthDateEpoch: result.birthDateEpoch,
              civilStatus: result.civilStatus,
              dateHiredEpoch: result.dateHiredEpoch,
              firstName: result.firstName,
              id: id,
              isDeactive: result.isDeactive,
              lastName: result.lastName,
              nuxifyId: result.nuxifyId,
              pagIbigNo: result.pagIbigNo,
              philHealtNo: result.philHealthNo,
              position: result.position,
              profileImageSource: result.profileImageSource,
              sssNo: result.sssNo,
              tinNo: result.tinNo,
            ),
          );
        }
      }

      throw APIErrorResponse(
        message: errorSomethingWentWrong,
        errorCode: null,
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

      /// Check if ParseResponse is error is not null.
      if (resetResponse.error != null) {
        formatAPIErrorResponse(error: resetResponse.error!);
      }

      return APIResponse<void>(
        success: resetResponse.success,
        message: 'Successfully sent reset link to the email!',
        data: null,
        errorCode: null,
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
      )..set<bool?>(usersIsAdminField, payload.isAdmin ?? false);

      final ParseResponse signUpResponse = await user.signUp();

      /// Check if ParseResponse is error is not null.
      if (signUpResponse.error != null) {
        formatAPIErrorResponse(error: signUpResponse.error!);
      }

      return APIResponse<void>(
        success: true,
        message: 'Successfully registered.',
        errorCode: null,
        data: null,
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

        /// Check if ParseResponse is error is not null.
        if (logoutResponse.error != null) {
          formatAPIErrorResponse(error: logoutResponse.error!);
        }

        return APIResponse<void>(
          success: true,
          message: 'Successfully logged out.',
          errorCode: null,
          data: null,
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
