/// This object will contain the necessary field for project record.
class Project {
  Project({
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
