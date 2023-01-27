class TaskCardDTO {
  TaskCardDTO({
    required this.taskName,
    required this.taskID,
    required this.status,
  });

  final String taskName;
  final String taskID;
  final int status;
}
