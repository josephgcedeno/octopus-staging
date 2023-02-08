import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DSRRepository extends IDSRRepository {
  final DateTime today = DateTime.now();

  DateTime get currentDate => DateTime(today.year, today.month, today.day);

  Future<List<DSRWorks>> manageData({
    required List<dynamic> tasks,
    required String userName,
    required String date,
    String? filterByProject,
  }) async {
    final List<DSRWorks> data = <DSRWorks>[];
    for (final Map<String, String> task in tasks as List<Map<String, String>>) {
      final String projectName = ((await ParseObject(projectTagsTable)
                  .getObject(task['project_tag_id']!))
              .result as ParseObject)
          .get<String>(
        projectTagsProjectNameField,
      )!;

      (filterByProject != null &&
              filterByProject != 'None' &&
              filterByProject == projectName)
          ? data.add(
              DSRWorks(
                tagId: task['project_tag_id']!,
                text: task['text']!,
                user: userName,
                projectName: projectName,
                date: date,
              ),
            )
          : data.add(
              DSRWorks(
                tagId: task['project_tag_id']!,
                text: task['text']!,
                user: userName,
                projectName: projectName,
                date: date,
              ),
            );
    }
    return data;
  }

  @override
  Future<DSRResponse> getAllDSRRecordForSprint({
    required String sprintId,
    List<String> columns = const <String>[
      dsrsDoneField,
      dsrsWipField,
      dsrsBlockersField,
    ],
    String? userId,
    String? projectName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject dsrs = ParseObject(dsrsTable);
      final DateTime now = DateTime.now();
      final int date =
          epochFromDateTime(date: DateTime(now.year, now.month, now.day));

      final QueryBuilder<ParseObject> dsrQuery = QueryBuilder<ParseObject>(dsrs)
        ..whereEqualTo(dsrsSprintidField, sprintId)
        ..whereGreaterThanOrEqualsTo(
          dsrsDateField,
          startDate != null && endDate != null
              ? epochFromDateTime(date: startDate)
              : date,

          /// If no date range specified, then this Query will return the record of today's sprint.
        )
        ..whereLessThan(
          dsrsDateField,
          startDate != null && endDate != null
              ? epochFromDateTime(
                  date: DateTime(endDate.year, endDate.month, endDate.day + 1),
                )
              : epochFromDateTime(
                  date: DateTime(now.year, now.month, now.day + 1),
                ),

          /// If no date range specified, then this Query will return the record of today's sprint.
        )
        ..keysToReturn(<String>[dsrsUserIdField, dsrsDateField, ...columns])
        ..orderByAscending(dsrsDateField);

      /// If specified user id. Just query certain user.
      if (userId != null) dsrQuery.whereEqualTo(dsrsUserIdField, userId);

      final ParseResponse dsrResponse = await dsrQuery.query();

      final Map<String, List<DSRWorks>> datas = <String, List<DSRWorks>>{};

      if (dsrResponse.success && dsrResponse.results != null) {
        for (final ParseObject dsrDonePerUser
            in dsrResponse.results! as List<ParseObject>) {
          final String userName = ((await ParseUser.forQuery()
                      .getObject(dsrDonePerUser.get<String>(dsrsUserIdField)!))
                  .result as ParseObject)
              .get(usersNameField)!;

          final String date = DateFormat('EEE, MMM d, yyyy').format(
            dateTimeFromEpoch(
              epoch: dsrDonePerUser.get<int>(dsrsDateField)!,
            ),
          );

          for (final String column in columns) {
            final List<dynamic> tasks = dsrDonePerUser.get(column)!;

            if (datas.containsKey(column)) {
              datas[column]!.addAll(
                await manageData(
                  tasks: tasks,
                  userName: userName,
                  filterByProject: projectName,
                  date: date,
                ),
              );
              continue;
            }

            datas[column] = await manageData(
              tasks: tasks,
              userName: userName,
              filterByProject: projectName,
              date: date,
            );
          }
        }

        /// Return formatted data for admin.
        return DSRResponse(
          status: 'success',
          dsrs: <DSRRecord>[],
          data: datas,
        );
      }

      if (dsrResponse.error != null &&
          dsrResponse.error!.message ==
              'Successful request, but no results found') {
        return DSRResponse(
          dsrs: <DSRRecord>[],
          status: 'success',
        );
      }
      throw APIResponse<void>(
        success: false,
        message: dsrResponse.error != null ? dsrResponse.error!.message : '',
        data: null,
        errorCode:
            dsrResponse.error != null ? dsrResponse.error!.code as String : '',
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<SprintResponse> getAllSprints({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject sprint = ParseObject(sprintsTable);

      final QueryBuilder<ParseObject> sprintRecord =
          QueryBuilder<ParseObject>(sprint)..orderByAscending('createdAt');

      if (startDate != null && endDate != null) {
        /// Query the start date and end date.
        final DateTime endDateToQuery =
            DateTime(endDate.year, endDate.month, endDate.day + 1);
        sprintRecord
          ..whereGreaterThanOrEqualsTo(
            sprintsStartDateField,
            epochFromDateTime(date: startDate),
          )
          ..whereLessThan(
            sprintsEndDateField,
            epochFromDateTime(date: endDateToQuery),
          );
      }

      final ParseResponse sprintResponse = await sprintRecord.query();

      if (sprintResponse.success) {
        final List<SprintRecord> sprints = <SprintRecord>[];
        if (sprintResponse.results != null) {
          for (final ParseObject result
              in sprintResponse.results! as List<ParseObject>) {
            sprints.add(
              SprintRecord(
                id: result.objectId!,
                startDateEpoch: result.get<int>(sprintsStartDateField)!,
                endDateEpoch: result.get<int>(sprintsEndDateField)!,
              ),
            );
          }
        }
        return SprintResponse(
          sprints: sprints,
          status: 'success',
        );
      }

      throw APIResponse<void>(
        success: false,
        message:
            sprintResponse.error != null ? sprintResponse.error!.message : '',
        data: null,
        errorCode: sprintResponse.error != null
            ? sprintResponse.error!.code as String
            : '',
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  /// Get the sprint info within the duration from start date and end date to set for TODAY.
  Future<ParseObject?> sprintInfoQueryToday() async {
    final int fromDateTimeToEpoch = epochFromDateTime(date: currentDate);

    final QueryBuilder<ParseObject> todayRecord =
        QueryBuilder<ParseObject>(ParseObject(sprintsTable))
          ..whereGreaterThanOrEqualsTo(
            sprintsEndDateField,
            fromDateTimeToEpoch,
          )
          ..whereLessThanOrEqualTo(
            sprintsStartDateField,
            fromDateTimeToEpoch,
          );

    final ParseResponse queryTodayRecrod = await todayRecord.query();

    if (queryTodayRecrod.success && queryTodayRecrod.results != null) {
      return queryTodayRecrod.results!.first as ParseObject;
    }
    return null;
  }

  @override
  Future<DSRResponse> createDSRForToday() async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null) {
      final ParseObject dsrs = ParseObject(dsrsTable);

      final ParseObject? sprintInfo = await sprintInfoQueryToday();

      if (sprintInfo != null) {
        final String sprintId = sprintInfo.objectId!;
        final String userId = user.objectId!;
        const String workStatus = 'ABSENT';

        final int epochDateToday = epochFromDateTime(date: currentDate);

        /// Check if there is an exsiting dsr record
        final QueryBuilder<ParseObject> isAlreadyExisiting =
            QueryBuilder<ParseObject>(dsrs)
              ..whereEqualTo(dsrsSprintidField, sprintId)
              ..whereEqualTo(dsrsUserIdField, userId)
              ..whereEqualTo(dsrsDateField, epochDateToday);

        final ParseResponse isAlreadyExisitingResponse =
            await isAlreadyExisiting.query();

        /// If count is 0 create dsr record
        if (isAlreadyExisitingResponse.success &&
            isAlreadyExisitingResponse.count == 0) {
          dsrs
            ..set<String>(dsrsSprintidField, sprintId)
            ..set<String>(dsrsUserIdField, userId)
            ..set<int>(dsrsDateField, epochDateToday)
            ..set<List<dynamic>>(dsrsDoneField, <dynamic>[])
            ..set<List<dynamic>>(dsrsWipField, <dynamic>[])
            ..set<List<dynamic>>(dsrsBlockersField, <dynamic>[])
            ..set<String>(dsrsStatusField, workStatus);

          final ParseResponse createDSRResponse = await dsrs.save();

          if (createDSRResponse.success && createDSRResponse.results != null) {
            return DSRResponse(
              status: 'success',
              dsrs: <DSRRecord>[
                DSRRecord(
                  id: getResultId(createDSRResponse.results!),
                  sprintId: sprintId,
                  dateEpoch: epochDateToday,
                  done: <DSRWorkTrack>[],
                  wip: <DSRWorkTrack>[],
                  blockers: <DSRWorkTrack>[],
                  status: workStatus,
                ),
              ],
            );
          }
        } else if (isAlreadyExisitingResponse.success &&
            isAlreadyExisitingResponse.count == 1) {
          /// If there is an existing sprint with this date. Return the info.
          final ParseObject resultParseObject =
              getParseObject(isAlreadyExisitingResponse.results!);

          return DSRResponse(
            status: 'success',
            dsrs: <DSRRecord>[
              DSRRecord(
                id: resultParseObject.objectId!,
                sprintId: resultParseObject.get<String>(dsrsSprintidField)!,
                done: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsDoneField)!,
                ),
                wip: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsWipField)!,
                ),
                blockers: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsBlockersField)!,
                ),
                dateEpoch: resultParseObject.get<int>(dsrsDateField)!,
                status: workStatus,
              ),
            ],
          );
        }

        throw APIResponse<void>(
          success: false,
          message: isAlreadyExisitingResponse.error != null
              ? isAlreadyExisitingResponse.error!.message
              : '',
          data: null,
          errorCode: isAlreadyExisitingResponse.error != null
              ? isAlreadyExisitingResponse.error!.code as String
              : '',
        );
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<SprintResponse> addSprint({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

    if (user != null && user.get<bool>(usersIsAdminField)!) {
      final ParseObject sprints = ParseObject(sprintsTable);
      final QueryBuilder<ParseObject> isAlreadyExisiting =
          QueryBuilder<ParseObject>(sprints)
            ..whereEqualTo(
              sprintsStartDateField,
              epochFromDateTime(date: startDate),
            )
            ..whereEqualTo(
              sprintsEndDateField,
              epochFromDateTime(date: endDate),
            );
      final ParseResponse isAlreadyExisitingResponse =
          await isAlreadyExisiting.query();

      /// If count is 0 create sprint record
      if (isAlreadyExisitingResponse.success &&
          isAlreadyExisitingResponse.count == 0) {
        sprints.set<int>(
          sprintsStartDateField,
          epochFromDateTime(date: startDate),
        );
        sprints.set<int>(sprintsEndDateField, epochFromDateTime(date: endDate));

        final ParseResponse createSprint = await sprints.save();

        if (createSprint.success) {
          return SprintResponse(
            sprints: <SprintRecord>[
              SprintRecord(
                endDateEpoch: epochFromDateTime(date: endDate),
                id: getResultId(createSprint.results!),
                startDateEpoch: epochFromDateTime(date: startDate),
              ),
            ],
            status: 'success',
          );
        }
      } else if (isAlreadyExisitingResponse.success &&
          isAlreadyExisitingResponse.count > 0) {
        /// If there is an existing sprint with this date. Throw error.
        throw APIResponse<void>(
          success: false,
          message: 'There is an existing sprint with this date already',
          data: null,
          errorCode: null,
        );
      }
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<DSRResponse> addDSRWork({
    required String dsrId,
    required String column,
    required List<DSRWorkTrack> dsrworkTrack,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      final ParseObject dsrs = ParseObject(dsrsTable);

      dsrs
        ..objectId = dsrId
        ..set<List<DSRWorkTrack>>(column, dsrworkTrack);

      final ParseResponse saveDsrResponse = await dsrs.save();

      if (saveDsrResponse.success) {
        final ParseResponse dsrInfoAfterAdding = await dsrs.getObject(dsrId);

        if (dsrInfoAfterAdding.success && dsrInfoAfterAdding.results != null) {
          final ParseObject resultParseObject =
              getParseObject(dsrInfoAfterAdding.results!);

          return DSRResponse(
            status: 'success',
            dsrs: <DSRRecord>[
              DSRRecord(
                id: resultParseObject.objectId!,
                sprintId: resultParseObject.get<String>(dsrsSprintidField)!,
                done: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsDoneField)!,
                ),
                wip: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsWipField)!,
                ),
                blockers: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsBlockersField)!,
                ),
                status: resultParseObject.get<String>(dsrsStatusField)!,
                dateEpoch: resultParseObject.get<int>(dsrsDateField)!,
              )
            ],
          );
        }
      }

      throw APIResponse<void>(
        success: false,
        message:
            saveDsrResponse.error != null ? saveDsrResponse.error!.message : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<DSRResponse> updateDSRWorkStatus({
    required String dsrId,
    required String status,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      final ParseObject dsrs = ParseObject(dsrsTable);

      dsrs
        ..objectId = dsrId
        ..set<String>(dsrsStatusField, status);

      final ParseResponse saveDsrResponse = await dsrs.save();

      if (saveDsrResponse.success) {
        final ParseResponse dsrInfoAfterUpdating = await dsrs.getObject(dsrId);

        if (dsrInfoAfterUpdating.success &&
            dsrInfoAfterUpdating.results != null) {
          final ParseObject resultParseObject =
              getParseObject(dsrInfoAfterUpdating.results!);

          return DSRResponse(
            status: 'success',
            dsrs: <DSRRecord>[
              DSRRecord(
                id: resultParseObject.objectId!,
                sprintId: resultParseObject.get<String>(dsrsSprintidField)!,
                done: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsDoneField)!,
                ),
                wip: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsWipField)!,
                ),
                blockers: convertListDynamic(
                  resultParseObject.get<List<dynamic>>(dsrsBlockersField)!,
                ),
                status: resultParseObject.get<String>(dsrsStatusField)!,
                dateEpoch: resultParseObject.get<int>(dsrsDateField)!,
              )
            ],
          );
        }
      }

      throw APIResponse<void>(
        success: false,
        message:
            saveDsrResponse.error != null ? saveDsrResponse.error!.message : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }

  @override
  Future<DSRResponse> getAvailableDSRSForSprint({
    String? sprintId,
    String? dsrId,
  }) async {
    final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      final ParseObject sprints = ParseObject(dsrsTable);
      final QueryBuilder<ParseObject> getAllDSRQuery =
          QueryBuilder<ParseObject>(sprints)
            ..whereEqualTo(dsrsSprintidField, sprintId)
            ..whereEqualTo(dsrsUserIdField, user.objectId);

      final ParseResponse getAllDSRQueryResponse = dsrId != null
          ? await sprints.getObject(dsrId)
          : await getAllDSRQuery.query();

      if (getAllDSRQueryResponse.success) {
        final List<DSRRecord> dsrs = <DSRRecord>[];
        if (getAllDSRQueryResponse.results != null) {
          for (final ParseObject dsr
              in getAllDSRQueryResponse.results! as List<ParseObject>) {
            dsrs.add(
              DSRRecord(
                id: dsr.objectId!,
                done:
                    convertListDynamic(dsr.get<List<dynamic>>(dsrsDoneField)!),
                wip: convertListDynamic(dsr.get<List<dynamic>>(dsrsWipField)!),
                blockers: convertListDynamic(
                  dsr.get<List<dynamic>>(dsrsBlockersField)!,
                ),
                sprintId: dsr.get<String>(dsrsSprintidField)!,
                dateEpoch: dsr.get<int>(dsrsDateField)!,
                status: dsr.get<String>(dsrsStatusField)!,
              ),
            );
          }
        }

        return DSRResponse(
          dsrs: dsrs,
          status: 'success',
        );
      }

      throw APIResponse<void>(
        success: false,
        message: getAllDSRQueryResponse.error != null
            ? getAllDSRQueryResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    }

    throw APIResponse<void>(
      success: false,
      message: 'Something went wrong',
      data: null,
      errorCode: null,
    );
  }
}
