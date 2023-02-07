class ProjectTagResponse {
  final String status;
  final List<ProjectTag> projects;

  ProjectTagResponse({
    required this.status,
    required this.projects,
  });
}

class ProjectTag {
  final String id;
  final String projectName;
  final int dateEpoch;
  final String status;
  final String color;

  ProjectTag({
    required this.id,
    required this.projectName,
    required this.dateEpoch,
    required this.status,
    required this.color,
  });
}
