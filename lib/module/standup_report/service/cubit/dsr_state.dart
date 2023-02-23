part of 'dsr_cubit.dart';

class DSRState {
  const DSRState();
}

class FetchDatesLoading extends DSRState {
  const FetchDatesLoading();
}

class FetchDatesSuccess extends DSRState {
  const FetchDatesSuccess(this.dateString);

  final String dateString;
}

class FetchDatesFailed extends DSRState {
  const FetchDatesFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class InitializeDSRLoading extends DSRState {
  const InitializeDSRLoading();
}

class InitializeDSRSuccess extends DSRState {
  const InitializeDSRSuccess({
    required this.doing,
    required this.done,
    required this.blockers,
  });

  final List<Task> done;
  final List<Task> doing;
  final List<Task> blockers;
}

class InitializeDSRFailed extends DSRState {
  const InitializeDSRFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class ShowStatusPane extends DSRState {
  const ShowStatusPane();
}

class HideStatusPane extends DSRState {
  const HideStatusPane();
}

class ShowProjectPane extends DSRState {
  const ShowProjectPane();
}

class HideProjectPane extends DSRState {
  const HideProjectPane();
}

class UpdateTaskStatus extends DSRState {
  const UpdateTaskStatus(this.status);
  final String status;
}

class UpdateTaskLoading extends DSRState {
  const UpdateTaskLoading({
    required this.taskLabel,
    required this.status,
    required this.projectTagId,
  });

  final String taskLabel;
  final ProjectStatus status;
  final String projectTagId;
}

class UpdateTaskSuccess extends DSRState {
  const UpdateTaskSuccess({
    required this.doing,
    required this.done,
    required this.blockers,
  });

  final List<Task> done;
  final List<Task> doing;
  final List<Task> blockers;
}

class UpdateTaskFailed extends DSRState {
  const UpdateTaskFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchProjectsSuccess extends DSRState {
  const FetchProjectsSuccess({
    required this.projects,
  });

  final List<Project> projects;
}

class FetchProjectsFailed extends DSRState {
  const FetchProjectsFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class SetProjectLoading extends DSRState {
  const SetProjectLoading();
}

class SetProjectSuccess extends DSRState {
  const SetProjectSuccess({required this.project});

  final Project project;
}
