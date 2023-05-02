part of 'accomplishments_cubit.dart';

class AccomplishmentsState {
  AccomplishmentsState();
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
