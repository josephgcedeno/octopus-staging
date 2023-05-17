import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

enum UserRole { admin, client }

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nuxifyId,
    required this.birthDateEpoch,
    required this.address,
    required this.civilStatus,
    required this.dateHiredEpoch,
    required this.profileImageSource,
    required this.isDeactive,
    required this.position,
    required this.pagIbigNo,
    required this.sssNo,
    required this.tinNo,
    required this.philHealtNo,
    required this.userId,
  });

  final String id; // this id is from the employee record info
  final String firstName;
  final String lastName;
  final String nuxifyId;
  final int birthDateEpoch;
  final String address;
  final String civilStatus;
  final int dateHiredEpoch;
  final String profileImageSource;
  final bool isDeactive;
  final String position;
  // Government related ids
  final String pagIbigNo;
  final String sssNo;
  final String tinNo;
  final String philHealtNo;
  final String userId; // this id is from the main User id column.
}

class UseWithrRole extends User {
  UseWithrRole({
    required this.userRole,
    required String id,
    required String firstName,
    required String lastName,
    required String nuxifyId,
    required int birthDateEpoch,
    required String address,
    required String civilStatus,
    required int dateHiredEpoch,
    required String profileImageSource,
    required bool isDeactive,
    required String position,
    required String pagIbigNo,
    required String sssNo,
    required String tinNo,
    required String philHealtNo,
    required String userId,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          nuxifyId: nuxifyId,
          birthDateEpoch: birthDateEpoch,
          address: address,
          civilStatus: civilStatus,
          dateHiredEpoch: dateHiredEpoch,
          profileImageSource: profileImageSource,
          isDeactive: isDeactive,
          position: position,
          pagIbigNo: pagIbigNo,
          sssNo: sssNo,
          tinNo: tinNo,
          philHealtNo: philHealtNo,
          userId: userId,
        );

  final UserRole userRole;
}

@JsonSerializable()
class EmployeeDailyTimeRecord {
  EmployeeDailyTimeRecord({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.attendances,
  });
  
  factory EmployeeDailyTimeRecord.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$EmployeeDailyTimeRecordFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeDailyTimeRecordToJson(this);

  final String firstName;
  final String lastName;
  final String position;
  final List<DTRAttendance> attendances;
}

@JsonSerializable()
class DTRAttendance {
  DTRAttendance({
    required this.date,
    required this.timeInOut,
    required this.overTime,
  });

  factory DTRAttendance.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DTRAttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$DTRAttendanceToJson(this);

  final String date;
  final String timeInOut;
  final String overTime;
}
