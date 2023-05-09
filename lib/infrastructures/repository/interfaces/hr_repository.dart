import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';

abstract class IHRRepository {
  /// FOR ADMIN USE ONLY
  ///
  /// Adds a new credential with the given [username], [password], and [accountType].
  ///
  /// [username] - The username for the new credential.
  ///
  /// [password] - The password for the new credential.
  ///
  /// [accountType] - The type of account associated with the new credential.
  Future<APIResponse<Credential>> addCredential({
    required String username,
    required String password,
    required String accountType,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Retrieves a list of all credentials.
  ///
  /// [id] - (Optional) If provided, only credentials with the given ID will be returned.
  ///
  /// [accountType] - (Optional) If provided, only credentials with the given account type will be returned.
  Future<APIListResponse<Credential>> getAllCredentials({
    String? id,
    String? accountType,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Updates the credential with the given [id].
  ///
  /// [id] - The ID of the credential to update.
  ///
  /// [username] - (Optional) The new username for the credential, if provided.
  ///
  /// [password] - (Optional) The new password for the credential, if provided.
  ///
  /// [accountType] - (Optional) The new account type for the credential, if provided.
  Future<APIResponse<Credential>> updateCredential({
    required String id,
    String? username,
    String? password,
    String? accountType,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Deletes the credential with the given [id].
  ///
  /// [id] - The ID of the credential to delete.
  Future<APIResponse<void>> deleteCredential({
    required String id,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Creates a new `CompanyFilePdf` object in the Parse Server database with the given `fileType` and `fileSource`.
  ///
  /// [fileType] - A required `CompanyFileType` enum value representing the type of file to be created.
  ///
  /// [fileSource] - A required `String` value representing the file source, which could be a file path, URL, or binary data.
  Future<APIResponse<CompanyFilePdf>> createCompanyFile({
    required CompanyFileType fileType,
    required String fileSource,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Updates the `CompanyFilePdf` object with the given [id] in the Parse Server database with the provided optional [fileType] and [fileSource].
  ///
  /// [id] - A required `String` value representing the ID of the `CompanyFilePdf` object to update.
  ///
  /// [fileType] - An optional `CompanyFileType` enum value representing the updated file type.
  ///
  /// [fileSource] - An optional `String` value representing the updated file source, which could be a file path, URL, or binary data.
  Future<APIResponse<CompanyFilePdf>> updateCompanyFile({
    required String id,
    CompanyFileType? fileType,
    String? fileSource,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Deletes the company file with the given [id] from the API.
  ///
  /// [id] - The ID of the company file to delete.
  Future<APIResponse<void>> deleteCompanyFile({
    required String id,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Fetches a list of all company files that match the specified search criteria.
  ///
  /// [id] - (optional) The ID of the company file to retrieve.
  /// [fileType] - (optional) The type of company file to retrieve.
  Future<APIListResponse<CompanyFilePdf>> getAllCompanyFilePdf({
    String? id,
    CompanyFileType? fileType,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Adds access to an account for a user.
  ///
  /// [userId] - The ID of the user to grant access.
  /// [accountId] - The ID of the account to grant access to.
  Future<APIResponse<AccountUserAccess>> addAccessToAccount({
    required String userId,
    required String accountId,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Removes access to an account for a user.
  ///
  /// [userId] - The ID of the user to revoke access.
  /// [accountId] - The ID of the account to revoke access from.
  Future<APIResponse<AccountUserAccess>> removeAccessToAccount({
    required String userId,
    required String accountId,
  });
}
