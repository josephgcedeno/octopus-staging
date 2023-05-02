import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/user_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
        final EmployeeInfoParseObject employeeInfoParseObject =
            EmployeeInfoParseObject();
        final ParseUser userRecord = (ParseUser.forQuery()..objectId = id);

        final QueryBuilder<EmployeeInfoParseObject> isRecordAlreadyExist =
            QueryBuilder<EmployeeInfoParseObject>(employeeInfoParseObject)
              ..whereEqualTo(EmployeeInfoParseObject.keyUser, userRecord);

        final ParseResponse checkRecordResponse =
            await isRecordAlreadyExist.query();

        if (checkRecordResponse.error != null) {
          formatAPIErrorResponse(error: checkRecordResponse.error!);
        }

        if (checkRecordResponse.success && checkRecordResponse.count > 0) {
          throw APIErrorResponse(
            message: 'Cannot create new record. already existing!',
            errorCode: '409',
          );
        }
        
        final int birthDateEpoch = epochFromDateTime(date: birthDate);
        final int dateHiredEpoch = epochFromDateTime(date: dateHired);

        /// Add required fields
        employeeInfoParseObject
          ..user = userRecord
          ..firstName = firstName
          ..lastName = lastName
          ..nuxifyId = nuxifyId
          ..birthDateEpoch = birthDateEpoch
          ..address = address
          ..civilStatus = civilStatus
          ..dateHiredEpoch = dateHiredEpoch
          ..profileImageSource = profileImageSource
          ..isDeactive = false
          ..position = position
          ..pagIbigNo = pagIbigNo
          ..sssNo = sssNo
          ..tinNo = tinNo
          ..philHealthNo = philHealtNo;

        final ParseResponse employeeRecordResponse =
            await employeeInfoParseObject.save();

        if (employeeRecordResponse.error != null) {
          formatAPIErrorResponse(error: employeeRecordResponse.error!);
        }

        if (employeeRecordResponse.success &&
            employeeRecordResponse.results != null) {
          final String id = getResultId(employeeRecordResponse.results!);
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
    try {
      if (id.isEmpty) {
        throw APIErrorResponse(
          message: errorEmptyValue,
          errorCode: null,
        );
      }
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final EmployeeInfoParseObject employeeInfoParseObject =
            EmployeeInfoParseObject();

        /// Set the user record with id passed
        employeeInfoParseObject.objectId = id;

        employeeInfoParseObject.isDeactive = true;

        final ParseResponse userRecordResponse =
            await employeeInfoParseObject.save();

        if (userRecordResponse.error != null) {
          formatAPIErrorResponse(error: userRecordResponse.error!);
        }

        if (userRecordResponse.success && userRecordResponse.results != null) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final ParseResponse fetchUserInfo =
              await employeeInfoParseObject.getObject(id);

          if (fetchUserInfo.error != null) {
            formatAPIErrorResponse(error: fetchUserInfo.error!);
          }

          if (fetchUserInfo.success && fetchUserInfo.results != null) {
            final EmployeeInfoParseObject resultParseObject =
                EmployeeInfoParseObject.toCustomParseObject(
              data: fetchUserInfo.results!.first,
            );

            return APIResponse<User>(
              success: true,
              message: 'Successfully deactivate user.',
              data: User(
                id: id,
                address: resultParseObject.address,
                birthDateEpoch: resultParseObject.birthDateEpoch,
                dateHiredEpoch: resultParseObject.dateHiredEpoch,
                civilStatus: resultParseObject.civilStatus,
                firstName: resultParseObject.firstName,
                isDeactive: resultParseObject.isDeactive,
                lastName: resultParseObject.lastName,
                nuxifyId: resultParseObject.nuxifyId,
                pagIbigNo: resultParseObject.pagIbigNo,
                philHealtNo: resultParseObject.philHealthNo,
                position: resultParseObject.position,
                profileImageSource: resultParseObject.profileImageSource,
                sssNo: resultParseObject.sssNo,
                tinNo: resultParseObject.tinNo,
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
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final EmployeeInfoParseObject employeeRecord =
            EmployeeInfoParseObject();

        final QueryBuilder<EmployeeInfoParseObject> queryUser =
            QueryBuilder<EmployeeInfoParseObject>(employeeRecord);

        if (nuxifyId != null && nuxifyId != '') {
          queryUser.whereEqualTo(usersNuxifyIdField, nuxifyId);
        }

        if (firstName != null && firstName != '') {
          queryUser.whereContains(usersFirstNameField, firstName);
        }

        if (lastName != null && lastName != '') {
          queryUser.whereContains(usersLastNameField, lastName);
        }

        if (position != null && position != '') {
          queryUser.whereContains(usersPositionField, position);
        }

        if (isAdmin != null) {
          queryUser.whereEqualTo(usersIsAdminField, isAdmin);
        }
        if (address != null && address != '') {
          queryUser.whereContains(usersAddressField, address);
        }
        if (civilStatus != null && civilStatus != '') {
          queryUser.whereContains(usersCivilStatusField, civilStatus);
        }
        if (age != null) {
          final DateTime now = DateTime.now();
          final int lowerLimitBirthDateEpoch = epochFromDateTime(
            date: DateTime(now.year - age, now.month, now.day),
          );

          final int upperLimitBirthDateEpoch = epochFromDateTime(
            date: DateTime(now.year - age - 1, now.month, now.day),
          );

          queryUser.whereGreaterThan(
            usersBirthDateEpochField,
            upperLimitBirthDateEpoch,
          );
          queryUser.whereLessThan(
            usersBirthDateEpochField,
            lowerLimitBirthDateEpoch,
          );
        }

        final ParseResponse userRecordResponse = await queryUser.query();

        if (userRecordResponse.error != null) {
          formatAPIErrorResponse(error: userRecordResponse.error!);
        }
        final List<User> users = <User>[];

        if (userRecordResponse.success && userRecordResponse.results != null) {
          for (final ParseObject userRec
              in userRecordResponse.results! as List<ParseObject>) {
            final EmployeeInfoParseObject resultParseObject =
                EmployeeInfoParseObject.toCustomParseObject(data: userRec);

            users.add(
              User(
                id: resultParseObject.objectId!,
                address: resultParseObject.address,
                birthDateEpoch: resultParseObject.birthDateEpoch,
                dateHiredEpoch: resultParseObject.dateHiredEpoch,
                civilStatus: resultParseObject.civilStatus,
                firstName: resultParseObject.firstName,
                isDeactive: resultParseObject.isDeactive,
                lastName: resultParseObject.lastName,
                nuxifyId: resultParseObject.nuxifyId,
                pagIbigNo: resultParseObject.pagIbigNo,
                philHealtNo: resultParseObject.philHealthNo,
                position: resultParseObject.position,
                profileImageSource: resultParseObject.profileImageSource,
                sssNo: resultParseObject.sssNo,
                tinNo: resultParseObject.tinNo,
              ),
            );
          }
        }
        return APIListResponse<User>(
          success: true,
          message:
              'Successfully fetch user record. Total row is ${users.length}',
          data: users,
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
  }) async {
    try {
      if (id.isEmpty) {
        throw APIErrorResponse(
          message: 'Id should not be empty.',
          errorCode: null,
        );
      }
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseUser userRecord = ParseUser.forQuery();

        /// Set the user record with id passed
        userRecord.objectId = id;

        if (firstName != null && firstName != '') {
          userRecord.set<String>(usersFirstNameField, firstName);
        }
        if (lastName != null && lastName != '') {
          userRecord.set<String>(usersLastNameField, lastName);
        }
        if (nuxifyId != null && nuxifyId != '') {
          userRecord.set<String>(usersNuxifyIdField, nuxifyId);
        }
        if (birthDate != null) {
          final int birthDateEpoch = epochFromDateTime(date: birthDate);
          userRecord.set<int>(usersBirthDateEpochField, birthDateEpoch);
        }
        if (address != null && address != '') {
          userRecord.set<String>(usersAddressField, address);
        }

        if (civilStatus != null && civilStatus != '') {
          userRecord.set<String>(usersCivilStatusField, civilStatus);
        }

        if (dateHired != null) {
          final int dateHiredEpoch = epochFromDateTime(date: dateHired);

          userRecord.set<int>(usersDateHiredField, dateHiredEpoch);
        }

        if (profileImageSource != null && profileImageSource != '') {
          userRecord.set<String>(
            usersProfileImageSourceField,
            profileImageSource,
          );
        }

        if (position != null && position != '') {
          userRecord.set<String>(
            usersPositionField,
            position,
          );
        }

        if (pagIbigNo != null && pagIbigNo != '') {
          userRecord.set<String>(
            usersPagIbigNoField,
            pagIbigNo,
          );
        }

        if (sssNo != null && sssNo != '') {
          userRecord.set<String>(
            usersSSSNoField,
            sssNo,
          );
        }
        if (tinNo != null && tinNo != '') {
          userRecord.set<String>(
            usersTinNoField,
            tinNo,
          );
        }

        if (philHealtNo != null && philHealtNo != '') {
          userRecord.set<String>(
            usersPhilHealthNoField,
            philHealtNo,
          );
        }

        final ParseResponse userRecordResponse = await userRecord.save();

        if (userRecordResponse.error != null) {
          formatAPIErrorResponse(error: userRecordResponse.error!);
        }

        if (userRecordResponse.success && userRecordResponse.results != null) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(userRecordResponse.results!);
          final ParseResponse fetchUserInfo =
              await userRecord.getObject(objectId);

          if (fetchUserInfo.error != null) {
            formatAPIErrorResponse(error: fetchUserInfo.error!);
          }

          if (fetchUserInfo.success && fetchUserInfo.results != null) {
            final ParseObject resultParseObject =
                getParseObject(fetchUserInfo.results!);

            return APIResponse<User>(
              success: true,
              message: 'Successfully updated user info.',
              data: User(
                id: objectId,
                address: resultParseObject.get<String>(usersAddressField)!,
                birthDateEpoch:
                    resultParseObject.get<int>(usersBirthDateEpochField)!,
                dateHiredEpoch:
                    resultParseObject.get<int>(usersDateHiredField)!,
                civilStatus:
                    resultParseObject.get<String>(usersCivilStatusField)!,
                firstName: resultParseObject.get<String>(usersFirstNameField)!,
                isDeactive: resultParseObject.get<bool>(usersIsdDeactiveField)!,
                lastName: resultParseObject.get<String>(usersLastNameField)!,
                nuxifyId: resultParseObject.get<String>(usersNuxifyIdField)!,
                pagIbigNo: resultParseObject.get<String>(usersPagIbigNoField)!,
                philHealtNo:
                    resultParseObject.get<String>(usersPhilHealthNoField)!,
                position: resultParseObject.get<String>(usersPositionField)!,
                profileImageSource: resultParseObject
                    .get<String>(usersProfileImageSourceField)!,
                sssNo: resultParseObject.get<String>(usersSSSNoField)!,
                tinNo: resultParseObject.get<String>(usersTinNoField)!,
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
