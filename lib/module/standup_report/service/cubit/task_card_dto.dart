class TaskCardDTO {
  TaskCardDTO({
    required this.taskName,
    required this.projectId,
    required this.status,
  });

  final String taskName;
  final String projectId;
  final int status;
}
