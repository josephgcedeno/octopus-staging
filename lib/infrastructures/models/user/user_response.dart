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
  });

  final String id;
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
        );

  final UserRole userRole;
}
