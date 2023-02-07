import 'package:flutter_baas_parse/infastructures/models/dsr/dsr_request.dart';

class SprintResponse {
  final List<SprintRecord> sprints;
  final String status;
  SprintResponse({
    required this.sprints,
    required this.status,
  });
}

class SprintRecord {
  final int startDateEpoch;
  final int endDateEpoch;
  final String id;

  SprintRecord({
    required this.id,
    required this.startDateEpoch,
    required this.endDateEpoch,
  });
}

class DSRResponse {
  final String status;
  final List<DSRRecord> dsrs;

  /// This record is for admin access listing all data for every user.
  final Map<String, List<DSRWorks>>? data;

  DSRResponse({
    required this.status,
    required this.dsrs,
    this.data,
  });
}

/// DSRS from the user record.
class DSRRecord {
  final String id;
  final String sprintId;
  final List<DSRWorkTrack> done;
  final List<DSRWorkTrack> wip;
  final List<DSRWorkTrack> blockers;
  final int dateEpoch;
  final String status;

  DSRRecord({
    required this.id,
    required this.sprintId,
    required this.done,
    required this.wip,
    required this.blockers,
    required this.dateEpoch,
    required this.status,
  });
}

/// Object for done, wip, and blockers.
class DSRWorks {
  final String text;
  final String tagId;
  final String user;
  final String projectName;
  final String date;

  DSRWorks({
    required this.text,
    required this.tagId,
    required this.user,
    required this.projectName,
    required this.date,
  });
}
