import 'dart:io';

import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/hr_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/encrypt_helper.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

const String encrpyPassowrd = 'hdqvb3BVzVc2KH-u2WA9cSkgCSxPj9AJ';

class HRRepository extends IHRRepository {
  final EncryptionService encryptionService = EncryptionService(encrpyPassowrd);
  @override
  Future<APIResponse<Credential>> addCredential({
    required String username,
    required String password,
    required String accountType,
  }) async {
    try {
      if (username.isEmpty || password.isEmpty || accountType.isEmpty) {
        throw APIErrorResponse(
          message: errorEmptyValue,
          errorCode: null,
        );
      }

      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final AccountCredentialsParseObject accountCredentialsParseObject =
            AccountCredentialsParseObject();
        // Encrypt password for extra security.
        final String cipherText = encryptionService.encrypt(password);

        /// Add required fields
        accountCredentialsParseObject
          ..username = username
          ..password = cipherText
          ..accountType = accountType;

        final ParseResponse accountResponse =
            await accountCredentialsParseObject.save();

        if (accountResponse.error != null) {
          formatAPIErrorResponse(error: accountResponse.error!);
        }

        if (accountResponse.success && accountResponse.results != null) {
          final String id = getResultId(accountResponse.results!);
          return APIResponse<Credential>(
            success: true,
            message: 'Successfully created new account.',
            data: Credential(
              accountType: accountType,
              id: id,
              password: cipherText,
              username: username,
            ),
            errorCode: null,
          );
        }
      }
      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<Credential>> getAllCredentials({
    String? id,
    String? accountType,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final AccountCredentialsParseObject accountCredentialsParseObject =
            AccountCredentialsParseObject();

        final QueryBuilder<AccountCredentialsParseObject>
            queryAccountCredentials =
            QueryBuilder<AccountCredentialsParseObject>(
          accountCredentialsParseObject,
        );

        if (id != null) {
          queryAccountCredentials.whereEqualTo('objectId', id);
        }

        if (accountType != null) {
          queryAccountCredentials.whereEqualTo(
            AccountCredentialsParseObject.keyAccountType,
            accountType,
          );
        }

        final ParseResponse accountResponse =
            await queryAccountCredentials.query();

        if (accountResponse.error != null) {
          formatAPIErrorResponse(error: accountResponse.error!);
        }

        final List<Credential> credentials = <Credential>[];
        if (accountResponse.success && accountResponse.results != null) {
          final List<AccountCredentialsParseObject> allAccountsCasted =
              List<AccountCredentialsParseObject>.from(
            accountResponse.results ?? <dynamic>[],
          );

          for (final AccountCredentialsParseObject account
              in allAccountsCasted) {
            credentials.add(encryptionService.decryptCredential(account));
          }
        }

        return APIListResponse<Credential>(
          success: true,
          message: 'Successfully fetch all account.',
          data: credentials,
          errorCode: null,
        );
      }
      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<CompanyFilePdf>> createCompanyFile(
      {required CompanyFileType fileType, required String fileSource}) {
    // TODO: implement createCompanyFile
    throw UnimplementedError();
  }

  @override
  Future<APIResponse<void>> deleteCompanyFile({required String id}) {
    // TODO: implement deleteCompanyFile
    throw UnimplementedError();
  }

  @override
  Future<APIResponse<void>> deleteCredential({required String id}) {
    // TODO: implement deleteCredential
    throw UnimplementedError();
  }

  @override
  Future<APIListResponse<Credential>> getAllCompanyFilePdf(
      {String? id, CompanyFileType? fileType}) {
    // TODO: implement getAllCompanyFilePdf
    throw UnimplementedError();
  }

  @override
  Future<APIResponse<CompanyFilePdf>> updateCompanyFile(
      {required String id, CompanyFileType? fileType, String? fileSource}) {
    // TODO: implement updateCompanyFile
    throw UnimplementedError();
  }

  @override
  Future<APIResponse<Credential>> updateCredential(
      {required String id,
      String? username,
      String? password,
      String? accountType}) {
    // TODO: implement updateCredential
    throw UnimplementedError();
  }
}
