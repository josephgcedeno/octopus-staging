part of 'hr_cubit.dart';

class HrState {
  const HrState();
}

class HrInitial extends HrState {}

class FetchAllCredentialsLoading extends HrState {}

class FetchAllCredentialsSuccess extends HrState {
  FetchAllCredentialsSuccess({
    required this.credential,
  });

  final List<Credential> credential;
}

class FetchAllCredentialsFailed extends HrState {
  FetchAllCredentialsFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchPDFFileLoading extends HrState {}

class FetchPDFFileSuccess extends HrState {
  FetchPDFFileSuccess({
    required this.fileType,
    required this.companyFiles,
  });

  final CompanyFileType fileType;
  final List<CompanyFilePdf> companyFiles;
}

class FetchPDFFileFailed extends HrState {
  FetchPDFFileFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
