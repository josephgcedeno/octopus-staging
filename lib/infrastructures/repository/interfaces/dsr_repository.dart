import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';

abstract class IDSRRepository {
  /// FOR: ADMIN USE ONLY
  ///
  /// This function will add a sprint to the database.
  ///
  /// [startDate] a data that defines when is the start date of the sprint. It is in a datetime format and will converted to an epoch type when stored in the database.
  ///
  /// [endDate] a date that defines when is the end date of the sprint. It is in a datetime format and will converted to an epoch type when stored in the database.
  Future<APIResponse<SprintRecord>> addSprint({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// This function will get all the available sprints from the database.
  ///
  /// [startDate] an optional parameter to set an starting date range of fetching all the sprint record. If not set, it will return all of records.
  ///
  /// [endDate] an optional parameter to set an ending date range of fetching all the sprint record. If not set, it will return all of records.
  Future<APIListResponse<SprintRecord>> getAllSprints({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will get all the record of the DSR from a particular sprint. To display as a whole. With filters.
  ///
  /// [sprintId] this determines which sprint to query from.
  ///
  /// [columns] this determines which column should be displayed. It can only show done column.
  ///
  /// [projectId] this filters the result by project name given.
  ///
  /// [startDate] an optional parameter to set an starting date range of fetching all the sprint record. If not set, it will return all of records.
  ///
  /// [endDate] an optional parameter to set an ending date range of fetching all the sprint record. If not set, it will return all of records.
  Future<APIResponse<AllDSRItem>> getAllDSRRecordForSprint({
    required String sprintId,
    List<String> columns = const <String>[
      'done',
      'work_in_progress',
      'blockers'
    ],
    String? projectId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// This function will creates a dsr record for the day under the sprint.
  Future<APIResponse<DSRRecord>> createDSRForToday();

  /// This function will get all the available dsr for the given sprint. It will also return a certain dsr record to fetch individually.
  ///
  /// [sprintId] this will get all the dsr record of the user on a particular sprint.
  ///
  /// [dsrId] this will get an individual dsr record of the user base on a particular sprint.
  Future<APIListResponse<DSRRecord>> getAvailableDSRSForSprint({
    String? sprintId,
    String? dsrId,
  });

  /// This function will add/update/delete (done,wip,blockers) as a list of DSRWorkTrack to the database within the dsr item.
  ///
  /// [dsrId] this determines which record will be added, updated, or deleted.
  ///
  /// [column] this determines which field should be modified (done, wip, blockers)
  ///
  /// [dsrworkTrack] this contains the list of the item to be stored in the database.
  Future<APIResponse<DSRRecord>> updateDSREntries({
    required String dsrId,
    required String column,
    required List<DSRWorkTrack> dsrworkTrack,
  });

  /// This function will update the dsr's working status (Holiday, Working, Leave, and etc.).
  ///
  /// [dsrId] this determines which record will be updated.
  ///
  /// [status] this determines what is the status of the dsr (Holiday, Working, Leave, and etc.).
  Future<APIResponse<DSRRecord>> updateDSRWorkStatus({
    required String dsrId,
    required String status,
  });
}
