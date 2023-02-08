class ProjectTagResponse {
  ProjectTagResponse({
    required this.status,
    required this.projects,
  });

  final String status;
  final List<ProjectTag> projects;
}

class ProjectTag {
  ProjectTag({
    required this.id,
    required this.projectName,
    required this.dateEpoch,
    required this.status,
    required this.color,
  });

  final String id;
  final String projectName;
  final int dateEpoch;
  final String status;
  final String color;
}
