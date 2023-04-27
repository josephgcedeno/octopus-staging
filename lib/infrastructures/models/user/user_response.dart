class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nuxifyId,
    required this.birthDate,
    required this.address,
    required this.civilStatus,
    required this.dateHired,
    required this.imageSource,
    required this.isDeactive,
    required this.pagIbigNo,
    required this.sssNo,
    required this.tinNo,
    required this.philHealtNo,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String nuxifyId;
  final String birthDate;
  final String address;
  final String civilStatus;
  final String dateHired;
  final String imageSource;
  final bool isDeactive;
  // Government related ids
  final String pagIbigNo;
  final String sssNo;
  final String tinNo;
  final String philHealtNo;
}
