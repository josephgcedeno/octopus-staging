import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

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

  /// This function will creates a dsr record for the day under the sprint. After creating DSR, it will return DSRRecord object that contains id, sprint_id, done, wip, blockers, dateEpoch and status.
  Future<APIResponse<DSRRecord>> initializeDSR();

  /// This function will get all the available dsr for the given sprint. It will also return a certain dsr record to fetch individually.
  ///
  /// [sprintId] this will get all the dsr record of the user on a particular sprint.
  ///
  /// [dsrId] this will get an individual dsr record of the user base on a particular sprint.
  Future<APIListResponse<DSRRecord>> getAvailableDSRSForSprint({
    String? sprintId,
    String? dsrId,
  });

  /// This function will add/update/delete (done, work_in_progress, blockers) as a list of Task to the database within the dsr item.
  ///
  /// [dsrId] this determines which record will be added, updated, or deleted.
  ///
  /// [column] this determines which field should be modified (done, work_in_progress, blockers). This variables can be use to directly use the fields from the database [dsrsDoneField, dsrsWipField, dsrsBlockersField]
  ///
  /// [tasks] this contains the list of the item to be stored in the database.
  Future<APIResponse<DSRRecord>> updateDSREntries({
    required String dsrId,
    required String column,
    required List<Task> tasks,
  });

  /// This function will update the dsr's working status ('WORKING', 'SICK LEAVE' ,'VACATION LEAVE','ABSENT', 'HOLIDAY').
  ///
  /// [dsrId] this determines which record will be updated.
  ///
  /// [status] this determines what is the status of the dsr ('WORKING', 'SICK LEAVE' ,'VACATION LEAVE','ABSENT', 'HOLIDAY').
  Future<APIResponse<DSRRecord>> updateDSRWorkStatus({
    required String dsrId,
    required String status,
  });

  /// This function will get  the sprint info within the duration from start date and end date to set for today. It will return SprintRecord object that contains id, startDateEpoch (millisecondFromEpoch), and endDateEpoch (millisecondFromEpoch).
  Future<APIResponse<SprintRecord>> sprintInfoQueryToday();

  /// Fetches DSR records from the server for the specified users and time range.
  ///
  /// [users] A list of [User] objects representing the users for which DSR records are to be fetched.
  ///
  /// [projectId] string representing the project ID. If provided, only DSR records for the specified project will be fetched.
  ///
  /// [today] object representing the current date. If provided, only DSR records for this
  /// date will be fetched.
  ///
  /// [from] object representing the start of the time range. If provided, only DSR records from this date and onwards will be fetched.
  ///
  /// [to] object representing the end of the time range. If provided, only DSR records up to this date will be fetched.
  Future<APIListResponse<UserDSR>> fetchDSRRecord({
    required List<User> users,
    String? projectId,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  });
}
