enum CompanyFileType { policies, guidelines, background, organizationChart }

class Credential {
  Credential({
    required this.id,
    required this.username,
    required this.accountType,
  });

  final String id;
  final String username;
  final String accountType;
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
