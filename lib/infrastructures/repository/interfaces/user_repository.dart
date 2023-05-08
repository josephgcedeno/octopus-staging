import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

enum UserStatus { deactivate, activate }

abstract class IUserRepository {
  /// FOR ADMIN USE ONLY
  ///
  /// Fetches a list of users from the API, filtered by the given parameters.
  ///
  /// [nuxifyId] - An optional string representing the Nuxify ID of the user.
  ///
  /// [firstName] - An optional string representing the first name of the user.
  ///
  /// [lastName] - An optional string representing the last name of the user.
  ///
  /// [position] - An optional string representing the position of the user.
  ///
  /// [isAdmin] - An optional string representing whether the user is an admin.
  ///
  /// [address] - An optional string representing the address of the user.
  ///
  /// [civilStatus] - An optional string representing the civil status of the user.
  ///
  /// [age] - An optional integer representing the age of the user.
  ///
  /// [isDeactive] - An optional boolean representing whether the user is inactive.
  Future<APIListResponse<User>> fetchAllUser({
    String? nuxifyId,
    String? firstName,
    String? lastName,
    String? position,
    bool? isAdmin,
    String? address,
    String? civilStatus,
    int? age,
    bool? isDeactive,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Creates a new user in the API with the given information.
  ///
  /// [id] - The ID which created from register account to associate extra fields for employee record.
  ///
  /// [firstName] - The first name of the new user.
  ///
  /// [lastName] - The last name of the new user.
  ///
  /// [nuxifyId] - The Nuxify ID of the new user.
  ///
  /// [birthDate] - The birth date of the new user.
  ///
  /// [address] - The address of the new user.
  ///
  /// [civilStatus] - The civil status of the new user.
  ///
  /// [dateHired] - The date that the new user was hired.
  ///
  /// [profileImageSource] - The source of the new user's profile image.
  ///
  /// [position] - The source of the new user's profile image.
  ///
  /// [pagIbigNo] - The Pag-IBIG number of the new user.
  ///
  /// [sssNo] - The SSS number of the new user.
  ///
  /// [tinNo] - The TIN number of the new user.
  ///
  /// [philHealtNo] - The PhilHealth number of the new user.
  Future<APIResponse<User>> createUser({
    required String id,
    required String firstName,
    required String lastName,
    required String nuxifyId,
    required DateTime birthDate,
    required String address,
    required String civilStatus,
    required DateTime dateHired,
    required String profileImageSource,
    required String position,
    required String pagIbigNo,
    required String sssNo,
    required String tinNo,
    required String philHealtNo,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Updates the user with the given [id] in the API.
  ///
  /// [id] - The ID of the user to update.
  ///
  /// [firstName] - (Optional) The updated first name of the user.
  ///
  /// [lastName] - (Optional) The updated last name of the user.
  ///
  /// [nuxifyId] - (Optional) The updated Nuxify ID of the user.
  ///
  /// [birthDate] - (Optional) The updated birth date of the user.
  ///
  /// [address] - (Optional) The updated address of the user.
  ///
  /// [civilStatus] - (Optional) The updated civil status of the user.
  ///
  /// [dateHired] - (Optional) The updated date that the user was hired.
  ///
  /// [imageSource] - (Optional) The updated source of the user's profile image.
  ///
  /// [pagIbigNo] - (Optional) The updated Pag-IBIG number of the user.
  ///
  /// [sssNo] - (Optional) The updated SSS number of the user.
  ///
  /// [tinNo] - (Optional) The updated TIN number of the user.
  ///
  /// [philHealtNo] - (Optional) The updated PhilHealth number of the user.
  ///
  /// [position] - (Optional) The updated Position of the user.
  Future<APIResponse<User>> updateUser({
    required String id,
    String? firstName,
    String? lastName,
    String? nuxifyId,
    DateTime? birthDate,
    String? address,
    String? civilStatus,
    DateTime? dateHired,
    String? profileImageSource,
    String? pagIbigNo,
    String? sssNo,
    String? tinNo,
    String? philHealtNo,
    String? position,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// Deactivates or Activates the user with the given [id] in the API.
  ///
  /// [id] - The ID of the user to deactivate.
  ///
  /// [userStatus] - Determine if the account is to be deactivated or activated.
  Future<APIResponse<User>> updateUserStatus({
    required String id,
    required UserStatus userStatus,
  });

  /// FOR ADMIN USE ONLY
  ///
  /// This will create a User account in the user class.
  ///
  /// [email] - The email will be use to login the user.
  ///
  /// [password] - The password will be use to login the user.
  /// 
  /// [isAdmin] - This will deterimine what is the type of account.
  Future<APIResponse<String>> createUserAccount({
    required String email,
    required String password,
    required bool isAdmin,
  });
}
