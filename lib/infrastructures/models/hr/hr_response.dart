enum CompanyFileType { policies, guidelines, background, organizationChart }

class Credential {
  Credential({
    required this.id,
    required this.username,
    required this.password,
    required this.accountType,
  });

  final String id;
  final String username;
  final String accountType;
  final String password;
}

class CompanyFilePdf {
  CompanyFilePdf({
    required this.id,
    required this.fileSource,
    required this.companyFileType,
  });

  final String id;
  final String fileSource;
  final CompanyFileType companyFileType;
}

class AccountUserAccess {
  AccountUserAccess({
    required this.id,
    required this.userId,
    required this.accountId,
  });

  final String id;
  final String userId;
  final String accountId;
}
