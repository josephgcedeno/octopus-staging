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

  final List<DSRWorkTrack> done;
  final List<DSRWorkTrack> doing;
  final List<DSRWorkTrack> blockers;
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
  const UpdateTaskLoading({required this.taskLabel, required this.status});

  final String taskLabel;
  final ProjectStatus status;
}

class UpdateTaskSuccess extends DSRState {
  const UpdateTaskSuccess({
    required this.doing,
    required this.done,
    required this.blockers,
  });

  final List<DSRWorkTrack> done;
  final List<DSRWorkTrack> doing;
  final List<DSRWorkTrack> blockers;
}

class UpdateTaskFailed extends DSRState {
  const UpdateTaskFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
