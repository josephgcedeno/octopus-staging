import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';

/// This object will contain the necessary field for sprint record.
class SprintRecord {
  SprintRecord({
    required this.id,
    required this.startDateEpoch,
    required this.endDateEpoch,
  });
  final int startDateEpoch;
  final int endDateEpoch;
  final String id;
}

/// This record is for admin access listing all data for every user.
class AllDSRItem {
  AllDSRItem({
    required this.data,
  });

  final Map<String, List<DSRWorks>> data;
}

/// This object will contain the necessary field for DSR record.
class DSRRecord {
  DSRRecord({
    required this.id,
    required this.sprintId,
    required this.done,
    required this.wip,
    required this.blockers,
    required this.dateEpoch,
    required this.status,
  });

  final String id;
  final String sprintId;
  final List<Task> done;
  final List<Task> wip;
  final List<Task> blockers;
  final int dateEpoch;
  final String status;
}

/// Object for done, wip, and blockers.
class DSRWorks {
  DSRWorks({
    required this.text,
    required this.tagId,
    required this.user,
    required this.projectName,
    required this.date,
    required this.color,
  });

  final String text;
  final String tagId;
  final String user;
  final String projectName;
  final String date;
  final String color;
}
