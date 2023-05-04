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

  String _getCompanyFileType(CompanyFileType companyFileType) {
    switch (companyFileType) {
      case CompanyFileType.policies:
        return 'POLICIES';
      case CompanyFileType.guidelines:
        return 'GUIDELINES';
      case CompanyFileType.background:
        return 'BACKGROUND';
      case CompanyFileType.organizationChart:
        return 'ORGANIZATIOCHART';
    }
  }

  CompanyFileType _getCompanyFileTypeFromString(String companyFileType) {
    switch (companyFileType) {
      case 'POLICIES':
        return CompanyFileType.policies;
      case 'GUIDELINES':
        return CompanyFileType.guidelines;
      case 'BACKGROUND':
        return CompanyFileType.background;
      case 'ORGANIZATIOCHART':
        return CompanyFileType.organizationChart;
      default:
        return CompanyFileType.background;
    }
  }

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
  Future<APIResponse<Credential>> updateCredential({
    required String id,
    String? username,
    String? password,
    String? accountType,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final AccountCredentialsParseObject accountCredentialsParseObject =
            AccountCredentialsParseObject();
        accountCredentialsParseObject.objectId = id;

        if (username != null) {
          accountCredentialsParseObject.username = username;
        }
        if (password != null) {
          // Encrypt password for extra security.
          final String cipherText = encryptionService.encrypt(password);
          accountCredentialsParseObject.password = cipherText;
        }
        if (accountType != null) {
          accountCredentialsParseObject.accountType = accountType;
        }

        final ParseResponse accountResponse =
            await accountCredentialsParseObject.save();

        if (accountResponse.error != null) {
          formatAPIErrorResponse(error: accountResponse.error!);
        }

        if (accountResponse.success && accountResponse.results != null) {
          final String objectId = getResultId(accountResponse.results!);
          final ParseResponse fetchUserInfo =
              await accountCredentialsParseObject.getObject(objectId);

          if (fetchUserInfo.error != null) {
            formatAPIErrorResponse(error: fetchUserInfo.error!);
          }

          if (fetchUserInfo.success && fetchUserInfo.results != null) {
            final ParseObject resultParseObject =
                getParseObject(fetchUserInfo.results!);

            return APIResponse<Credential>(
              success: true,
              message: 'Successfully update account.',
              data: encryptionService.decryptCredential(
                resultParseObject as AccountCredentialsParseObject,
              ),
              errorCode: null,
            );
          }
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
  Future<APIResponse<void>> deleteCredential({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final AccountCredentialsParseObject accountCredentialsParseObject =
            AccountCredentialsParseObject();
        accountCredentialsParseObject.objectId = id;

        final ParseResponse accountResponse =
            await accountCredentialsParseObject.delete();

        if (accountResponse.error != null) {
          formatAPIErrorResponse(error: accountResponse.error!);
        }

        if (accountResponse.success && accountResponse.results != null) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully delete account.',
            data: null,
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
  Future<APIResponse<CompanyFilePdf>> createCompanyFile({
    required CompanyFileType fileType,
    required String fileSource,
  }) async {
    try {
      if (fileSource.isEmpty) {
        throw APIErrorResponse(
          message: errorEmptyValue,
          errorCode: null,
        );
      }

      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final CompanyFilePDFParseObject companyFilePDFParseObject =
            CompanyFilePDFParseObject();
        // Encrypt password for extra security.

        /// Add required fields
        companyFilePDFParseObject
          ..fileSource = fileSource
          ..companyFileType = _getCompanyFileType(fileType);

        final ParseResponse companyFileCreate =
            await companyFilePDFParseObject.save();

        if (companyFileCreate.error != null) {
          formatAPIErrorResponse(error: companyFileCreate.error!);
        }

        if (companyFileCreate.success && companyFileCreate.results != null) {
          final String id = getResultId(companyFileCreate.results!);
          return APIResponse<CompanyFilePdf>(
            success: true,
            message: 'Successfully created new file PDF.',
            data: CompanyFilePdf(
              companyFileType: fileType,
              fileSource: fileSource,
              id: id,
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
  Future<APIResponse<void>> deleteCompanyFile({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final CompanyFilePDFParseObject companyFilePDFParseObject =
            CompanyFilePDFParseObject();
        companyFilePDFParseObject.objectId = id;

        final ParseResponse deleteResponse =
            await companyFilePDFParseObject.delete();

        if (deleteResponse.error != null) {
          formatAPIErrorResponse(error: deleteResponse.error!);
        }

        if (deleteResponse.success && deleteResponse.results != null) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully delete file PDF.',
            data: null,
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
  Future<APIListResponse<CompanyFilePdf>> getAllCompanyFilePdf({
    String? id,
    CompanyFileType? fileType,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final CompanyFilePDFParseObject companyFilePDFParseObject =
            CompanyFilePDFParseObject();

        final QueryBuilder<CompanyFilePDFParseObject> queryGetAllFile =
            QueryBuilder<CompanyFilePDFParseObject>(companyFilePDFParseObject);

        if (id != null) {
          queryGetAllFile.whereEqualTo('objectId', id);
        }
        if (fileType != null) {
          queryGetAllFile.whereEqualTo(
            CompanyFilePDFParseObject.keyCompanyFileType,
            _getCompanyFileType(fileType),
          );
        }

        final ParseResponse getAllCompanyFile = await queryGetAllFile.query();

        if (getAllCompanyFile.error != null) {
          formatAPIErrorResponse(error: getAllCompanyFile.error!);
        }

        final List<CompanyFilePdf> companyFilesPdf = <CompanyFilePdf>[];

        if (getAllCompanyFile.success && getAllCompanyFile.results != null) {
          final List<CompanyFilePDFParseObject> allFileCasted =
              List<CompanyFilePDFParseObject>.from(
            getAllCompanyFile.results ?? <dynamic>[],
          );

          for (final CompanyFilePDFParseObject companyFile in allFileCasted) {
            companyFilesPdf.add(
              CompanyFilePdf(
                companyFileType:
                    _getCompanyFileTypeFromString(companyFile.companyFileType),
                fileSource: companyFile.fileSource,
                id: companyFile.objectId!,
              ),
            );
          }
        }

        return APIListResponse<CompanyFilePdf>(
          success: true,
          message: 'Successfully fetch all file PDF.',
          data: companyFilesPdf,
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
  Future<APIResponse<CompanyFilePdf>> updateCompanyFile({
    required String id,
    CompanyFileType? fileType,
    String? fileSource,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final CompanyFilePDFParseObject companyFilePDFParseObject =
            CompanyFilePDFParseObject();
        companyFilePDFParseObject.objectId = id;

        if (fileType != null) {
          companyFilePDFParseObject.companyFileType =
              _getCompanyFileType(fileType);
        }
        if (fileSource != null) {
          companyFilePDFParseObject.fileSource = fileSource;
        }

        final ParseResponse companyFileUpdateResponse =
            await companyFilePDFParseObject.save();

        if (companyFileUpdateResponse.error != null) {
          formatAPIErrorResponse(error: companyFileUpdateResponse.error!);
        }

        if (companyFileUpdateResponse.success &&
            companyFileUpdateResponse.results != null) {
          final String objectId =
              getResultId(companyFileUpdateResponse.results!);
          final ParseResponse fetchUserInfo =
              await companyFilePDFParseObject.getObject(objectId);

          if (fetchUserInfo.error != null) {
            formatAPIErrorResponse(error: fetchUserInfo.error!);
          }

          if (fetchUserInfo.success && fetchUserInfo.results != null) {
            final CompanyFilePDFParseObject resultParseObject =
                getParseObject(fetchUserInfo.results!)
                    as CompanyFilePDFParseObject;

            return APIResponse<CompanyFilePdf>(
              success: true,
              message: 'Successfully update company file.',
              data: CompanyFilePdf(
                companyFileType: _getCompanyFileTypeFromString(
                  resultParseObject.companyFileType,
                ),
                fileSource: resultParseObject.fileSource,
                id: resultParseObject.objectId!,
              ),
              errorCode: null,
            );
          }
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
}
