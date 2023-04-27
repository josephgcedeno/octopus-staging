import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UserRepository extends IUserRepository {
  @override
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
  }) async {
    try {
      if (id.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          nuxifyId.isEmpty ||
          address.isEmpty ||
          civilStatus.isEmpty ||
          profileImageSource.isEmpty ||
          position.isEmpty ||
          pagIbigNo.isEmpty ||
          sssNo.isEmpty ||
          tinNo.isEmpty ||
          philHealtNo.isEmpty) {
        throw APIErrorResponse(
          message: errorEmptyValue,
          errorCode: null,
        );
      }
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseUser userRecord = ParseUser.forQuery();

        /// Set the user record with id passed
        userRecord.objectId = id;

        final int birthDateEpoch = epochFromDateTime(date: birthDate);
        final int dateHiredEpoch = epochFromDateTime(date: dateHired);

        /// Add required fields
        userRecord
          ..set<String>(usersFirstNameField, firstName)
          ..set<String>(usersLastNameField, lastName)
          ..set<String>(usersNuxifyIdField, nuxifyId)
          ..set<int>(usersBirthDateEpochField, birthDateEpoch)
          ..set<String>(usersAddressField, address)
          ..set<String>(usersCivilStatusField, civilStatus)
          ..set<int>(usersDateHiredField, dateHiredEpoch)
          ..set<String>(usersProfileImageSourceField, profileImageSource)
          ..set<bool>(usersIsdDeactiveField, false)
          ..set<String>(usersPositionField, position)
          ..set<String>(usersPagIbigNoField, pagIbigNo)
          ..set<String>(usersSSSNoField, sssNo)
          ..set<String>(usersTinNoField, tinNo)
          ..set<String>(usersPhilHealthNoField, philHealtNo);

        final ParseResponse userRecordResponse = await userRecord.save();

        if (userRecordResponse.error != null) {
          formatAPIErrorResponse(error: userRecordResponse.error!);
        }

        if (userRecordResponse.success && userRecordResponse.results != null) {
          final String id = getResultId(userRecordResponse.results!);
          return APIResponse<User>(
            success: true,
            message: 'Successfully created user record.',
            data: User(
              id: id,
              address: address,
              birthDateEpoch: birthDateEpoch,
              dateHiredEpoch: dateHiredEpoch,
              civilStatus: civilStatus,
              firstName: firstName,
              isDeactive: false,
              lastName: lastName,
              nuxifyId: nuxifyId,
              pagIbigNo: pagIbigNo,
              philHealtNo: philHealtNo,
              position: position,
              profileImageSource: profileImageSource,
              sssNo: sssNo,
              tinNo: tinNo,
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
  Future<APIResponse<User>> deactivateUser({required String id}) async {
    // TODO: implement deactivateUser
    throw UnimplementedError();
  }

  @override
  Future<APIListResponse<User>> fetchAllUser({
    String? nuxifyId,
    String? firstName,
    String? lastName,
    String? currentPosition,
    String? isAdmin,
    String? address,
    String? civilStatus,
    int? age,
    bool? isDeactive,
  }) async {
    // TODO: implement fetchAllUser
    throw UnimplementedError();
  }

  @override
  Future<APIResponse<User>> updateUser({
    required String id,
    String? firstName,
    String? lastName,
    String? nuxifyId,
    String? birthDate,
    String? address,
    String? civilStatus,
    String? dateHired,
    String? imageSource,
    String? pagIbigNo,
    String? sssNo,
    String? tinNo,
    String? philHealtNo,
    String? position,
  }) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
