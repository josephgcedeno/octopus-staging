part of 'accomplishments_cubit.dart';

class AccomplishmentsState {
  AccomplishmentsState({
    this.selectedTasks,
  });

  Map<String, List<DSRWorks>>? selectedTasks;
}

class FetchAllAccomplishmentsDataLoading extends AccomplishmentsState {
  FetchAllAccomplishmentsDataLoading();
}

class FetchAllAccomplishmentsDataSuccess extends AccomplishmentsState {
  FetchAllAccomplishmentsDataSuccess({
    required this.projects,
    required this.tasks,
  });
  final Map<String, List<DSRWorks>> tasks;
  final List<Project> projects;
}

class FetchAllAccomplishmentsDataFailed extends AccomplishmentsState {
  FetchAllAccomplishmentsDataFailed({
    required this.errorCode,
    required this.message,
  });
  final String errorCode;
  final String message;
}

class GeneratePDFLoading extends AccomplishmentsState {}

class GeneratePDFSuccess extends AccomplishmentsState {
  GeneratePDFSuccess(this.document);

  final Uint8List document;
}

class GeneratePDFFailed extends AccomplishmentsState {
  GeneratePDFFailed({
    required this.errorCode,
    required this.message,
  });
  final String errorCode;
  final String message;
}
