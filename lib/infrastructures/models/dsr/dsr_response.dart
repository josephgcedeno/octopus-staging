import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';

class SprintResponse {
  SprintResponse({
    required this.sprints,
    required this.status,
  });
  final List<SprintRecord> sprints;
  final String status;
}

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

class DSRResponse {
  DSRResponse({
    required this.status,
    required this.dsrs,
    this.data,
  });
  final String status;
  final List<DSRRecord> dsrs;

  /// This record is for admin access listing all data for every user.
  final Map<String, List<DSRWorks>>? data;
}

/// DSRS from the user record.
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
  final List<DSRWorkTrack> done;
  final List<DSRWorkTrack> wip;
  final List<DSRWorkTrack> blockers;
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
  });

  final String text;
  final String tagId;
  final String user;
  final String projectName;
  final String date;
}
