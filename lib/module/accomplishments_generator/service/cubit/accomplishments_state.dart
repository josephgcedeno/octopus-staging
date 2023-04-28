part of 'accomplishments_cubit.dart';

class AccomplishmentsState {
  AccomplishmentsState();
}

class FetchAllAccomplishmentsLoading extends AccomplishmentsState {
  FetchAllAccomplishmentsLoading();
}

class FetchAllAccomplishmentsSuccess extends AccomplishmentsState {
  FetchAllAccomplishmentsSuccess({required this.tasks});

  final Map<String, List<DSRWorks>>? tasks;
}

class FetchAllAccomplishmentsFailed extends AccomplishmentsState {
  FetchAllAccomplishmentsFailed(
      {required this.errorCode, required this.message,});
  final String errorCode;
  final String message;
}

class FetchAllProjectsLoading extends AccomplishmentsState {
  FetchAllProjectsLoading();
}

class FetchAllProjectsSuccess extends AccomplishmentsState {
  FetchAllProjectsSuccess({required this.projects});
  final List<Project> projects;
}

class FetchAllProjectsFailed extends AccomplishmentsState {
  FetchAllProjectsFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}

class FetchAllSprintsLoading extends AccomplishmentsState {
  FetchAllSprintsLoading();
}

class FetchAllSprintsSuccess extends AccomplishmentsState {
  FetchAllSprintsSuccess({required this.projects});
  final List<Project> projects;
}

class FetchAllSprintsFailed extends AccomplishmentsState {
  FetchAllSprintsFailed({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
}

class FetchAllAccomplishmentsDataLoading extends AccomplishmentsState {
  FetchAllAccomplishmentsDataLoading();
}

class FetchAllAccomplishmentsDataSuccess extends AccomplishmentsState {
  FetchAllAccomplishmentsDataSuccess(
      {required this.projects, required this.tasks,});
  final Map<String, List<DSRWorks>> tasks;
  final List<Project> projects;
}

class FetchAllAccomplishmentsDataFailed extends AccomplishmentsState {
  FetchAllAccomplishmentsDataFailed(
      {required this.errorCode, required this.message,});
  final String errorCode;
  final String message;
}
