import 'dart:io';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DSRRepository extends IDSRRepository {
  final DateTime today = DateTime.now();

  /// This list down the available column to update the entries (done, work_in_progress, and blockers)
  List<String> get columnsEntries => const <String>[
        dsrsDoneField,
        dsrsWipField,
        dsrsBlockersField,
      ];

  DateTime get currentDate => DateTime(today.year, today.month, today.day);

  Future<List<DSRWorks>> manageData({
    required List<dynamic> tasks,
    required String userName,
    required String date,
    String? filterByProjectId,
  }) async {
    final List<DSRWorks> data = <DSRWorks>[];
    for (final dynamic task in tasks) {
      final Map<String, dynamic> parseTask = task as Map<String, dynamic>;

      final String projectTagId = parseTask['project_tag_id']!.toString();

      /// Check if the filterByProjectId is not null and the current project id does not match the filterByProjectId then just continue.
      if (filterByProjectId != null && projectTagId != filterByProjectId) {
        continue;
      }
      final String text = parseTask['text']!.toString();

      final String projectName =
          ((await ParseObject(projectTagsTable).getObject(projectTagId)).result
                  as ParseObject)
              .get<String>(
        projectTagsProjectNameField,
      )!;

      data.add(
        DSRWorks(
          tagId: projectTagId,
          text: text,
          user: userName,
          projectName: projectName,
          date: date,
        ),
      );
    }
    return data;
  }

  /// This will check if the sprint id does exist in the database.
  Future<bool> isSprintIdExist(String sprintId) async {
    final ParseObject dsrs = ParseObject(sprintsTable);
    final ParseResponse doesExistSprintIdResponse =
        await dsrs.getObject(sprintId);
    if (doesExistSprintIdResponse.count == 0) {
      throw APIErrorResponse(
        message: doesExistSprintIdResponse.error != null
            ? 'There is no sprint id $sprintId exist.'
            : '',
        errorCode: doesExistSprintIdResponse.error != null
            ? doesExistSprintIdResponse.error!.code.toString()
            : '',
      );
    }
    return true;
  }

  Future<bool> isDSRIdExist(String dsrId) async {
    final ParseObject dsrs = ParseObject(dsrsTable);
    final ParseResponse doesExistDSRIdResponse = await dsrs.getObject(dsrId);
    if (doesExistDSRIdResponse.count == 0) {
      throw APIErrorResponse(
        message: doesExistDSRIdResponse.error != null
            ? 'There is no dsr id $dsrId exist.'
            : '',
        errorCode: doesExistDSRIdResponse.error != null
            ? doesExistDSRIdResponse.error!.code.toString()
            : '',
      );
    }
    return true;
  }

  /// This will check if the user
  Future<bool> isUserIdExist(String userId) async {
    const String objectIdField = 'objectId';
    final QueryBuilder<ParseObject> queryGetUserId = QueryBuilder<ParseObject>(
      ParseObject(usersTable),
    )
      ..whereEqualTo(objectIdField, userId)
      ..keysToReturn(<String>[objectIdField]);
    final ParseResponse queryGetUserIdResponse = await queryGetUserId.query();
    if (queryGetUserIdResponse.count == 0) {
      throw APIErrorResponse(
        message: queryGetUserIdResponse.error != null
            ? 'There is no user id $userId exist.'
            : '',
        errorCode: queryGetUserIdResponse.error != null
            ? queryGetUserIdResponse.error!.code.toString()
            : '',
      );
    }
    return true;
  }

  /// This will check if the project ID/s does exist. It will only take either between multiple project id or single project id.
  ///
  /// [dsrRecords] this will be use to check multiple project ids.
  ///
  /// [projectId] this will check if the project id is exis
  Future<bool> doesProjectIdExist({
    List<DSRWorkTrack>? dsrRecords,
    String? projectId,
  }) async {
    final ParseObject project = ParseObject(projectTagsTable);
    if (dsrRecords != null) {
      final QueryBuilder<ParseObject> queryGetActiveProject =
          QueryBuilder<ParseObject>(
        project,
      )
            ..whereEqualTo(projectTagsProjectStatusField, 'ACTIVE')
            ..keysToReturn(<String>['objectId']);

      final ParseResponse queryGetActiveProjetResponse =
          await queryGetActiveProject.query();
      if (queryGetActiveProjetResponse.success &&
          queryGetActiveProjetResponse.results != null) {
        final List<ParseObject> projects =
            queryGetActiveProjetResponse.results! as List<ParseObject>;
        for (final DSRWorkTrack dsr in dsrRecords) {
          if (!projects
              .any((ParseObject item) => item.objectId == dsr.projectTagId)) {
            throw APIErrorResponse(
              message: 'The project ${dsr.projectTagId} does not exist.',
              errorCode: null,
            );
          }
        }
        return true;
      }
    } else if (projectId != null) {
      final ParseResponse projectIdResponse =
          await project.getObject(projectId);

      if (projectIdResponse.count == 0) {
        throw APIErrorResponse(
          message: projectIdResponse.error != null
              ? 'There is no project id $projectId exist.'
              : '',
          errorCode: projectIdResponse.error != null
              ? projectIdResponse.error!.code.toString()
              : '',
        );
      }
      return true;
    }

    throw APIErrorResponse(
      message: 'There is no project id does not exist.',
      errorCode: null,
    );
  }

  @override
  Future<APIResponse<AllDSRItem>> getAllDSRRecordForSprint({
    required String sprintId,
    List<String> columns = const <String>[
      dsrsDoneField,
      dsrsWipField,
      dsrsBlockersField,
    ],
    String? userId,
    String? projectId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        /// Check if the sprint id is empty, afterward check if the sprint id does exist in the database.
        if (sprintId.isEmpty) {
          throw APIErrorResponse(
            errorCode: null,
            message: 'Sprint ID cannot be empty',
          );
        }

        /// If the sprint id does exist proceed to fetching record.
        if (await isSprintIdExist(sprintId)) {
          final ParseObject dsrs = ParseObject(dsrsTable);
          final DateTime now = DateTime.now();
          final int date =
              epochFromDateTime(date: DateTime(now.year, now.month, now.day));

          final QueryBuilder<ParseObject> dsrQuery = QueryBuilder<ParseObject>(
            dsrs,
          )
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
                      date: DateTime(
                        endDate.year,
                        endDate.month,
                        endDate.day + 1,
                      ),
                    )
                  : epochFromDateTime(
                      date: DateTime(now.year, now.month, now.day + 1),
                    ),

              /// If no date range specified, then this Query will return the record of today's sprint.
            )
            ..keysToReturn(<String>[dsrsUserIdField, dsrsDateField, ...columns])
            ..orderByAscending(dsrsDateField);

          /// If specified user id. Just query certain user.
          if (userId != null) {
            final bool isUserExist = await isUserIdExist(userId);
            dsrQuery.whereEqualTo(dsrsUserIdField, isUserExist ? userId : '');
          }

          /// Check if filter by project id does exist.
          if (projectId != null) await doesProjectIdExist(projectId: projectId);

          final ParseResponse dsrResponse = await dsrQuery.query();
          final Map<String, List<DSRWorks>> datas = <String, List<DSRWorks>>{};
          if (dsrResponse.success) {
            if (dsrResponse.results != null) {
              for (final ParseObject dsrDonePerUser
                  in dsrResponse.results! as List<ParseObject>) {
                final String userName = ((await ParseUser.forQuery().getObject(
                  dsrDonePerUser.get<String>(dsrsUserIdField)!,
                ))
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
                        filterByProjectId: projectId,
                        date: date,
                      ),
                    );
                    continue;
                  }

                  datas[column] = await manageData(
                    tasks: tasks,
                    userName: userName,
                    filterByProjectId: projectId,
                    date: date,
                  );
                }
              }
            }

            /// Return formatted data for admin.
            return APIResponse<AllDSRItem>(
              success: true,
              data: AllDSRItem(
                data: datas,
              ),
              errorCode: null,
              message: 'success',
            );
          }
          throw APIErrorResponse(
            message:
                dsrResponse.error != null ? dsrResponse.error!.message : '',
            errorCode: dsrResponse.error != null
                ? dsrResponse.error!.code as String
                : '',
          );
        }
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<SprintRecord>> getAllSprints({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
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
          return APIListResponse<SprintRecord>(
            success: true,
            message: 'Successfully retrieve sprints',
            data: sprints,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message:
              sprintResponse.error != null ? sprintResponse.error!.message : '',
          errorCode: sprintResponse.error != null
              ? sprintResponse.error!.code as String
              : '',
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<SprintRecord>> sprintInfoQueryToday() async {
    try {
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

      final ParseResponse queryTodayRecord = await todayRecord.query();

      if (queryTodayRecord.success && queryTodayRecord.results != null) {
        final ParseObject sprintInfo =
            getParseObject(queryTodayRecord.results!);

        return APIResponse<SprintRecord>(
          success: true,
          message: 'Successfully get the sprint record for this day.',
          data: SprintRecord(
            id: sprintInfo.objectId!,
            startDateEpoch: sprintInfo.get<int>(sprintsStartDateField)!,
            endDateEpoch: sprintInfo.get<int>(sprintsEndDateField)!,
          ),
          errorCode: null,
        );
      }
      throw APIErrorResponse(
        message: queryTodayRecord.error != null
            ? queryTodayRecord.error!.message
            : '',
        errorCode: queryTodayRecord.error != null
            ? queryTodayRecord.error!.code as String
            : '',
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<DSRRecord>> initializeDSR() async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        final ParseObject dsrs = ParseObject(dsrsTable);

        final APIResponse<SprintRecord> sprintInfo =
            await sprintInfoQueryToday();

        if (sprintInfo.success) {
          final String sprintId = sprintInfo.data.id;
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

            if (createDSRResponse.success &&
                createDSRResponse.results != null) {
              return APIResponse<DSRRecord>(
                success: true,
                message: 'Successfully created DSR.',
                data: DSRRecord(
                  id: getResultId(createDSRResponse.results!),
                  sprintId: sprintId,
                  dateEpoch: epochDateToday,
                  done: <DSRWorkTrack>[],
                  wip: <DSRWorkTrack>[],
                  blockers: <DSRWorkTrack>[],
                  status: workStatus,
                ),
                errorCode: null,
              );
            }
          } else if (isAlreadyExisitingResponse.success &&
              isAlreadyExisitingResponse.count == 1) {
            /// If there is an existing sprint with this date. Return the info.
            final ParseObject resultParseObject =
                getParseObject(isAlreadyExisitingResponse.results!);

            return APIResponse<DSRRecord>(
              success: true,
              message: 'There is an already record for today.',
              data: DSRRecord(
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
              errorCode: null,
            );
          }

          throw APIErrorResponse(
            message: isAlreadyExisitingResponse.error != null
                ? isAlreadyExisitingResponse.error!.message
                : '',
            errorCode: isAlreadyExisitingResponse.error != null
                ? isAlreadyExisitingResponse.error!.code as String
                : '',
          );
        }
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<SprintRecord>> addSprint({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        /// Check if the sprint is 2 weeks range.
        if (endDate != startDate.add(const Duration(days: 14))) {
          throw APIErrorResponse(
            message:
                'The range between start date and end date does not match with the two weeks sprint.',
            errorCode: null,
          );
        }

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
          sprints.set<int>(
            sprintsEndDateField,
            epochFromDateTime(date: endDate),
          );

          final ParseResponse createSprint = await sprints.save();

          if (createSprint.success) {
            return APIResponse<SprintRecord>(
              success: true,
              message: 'Successfully add sprint.',
              data: SprintRecord(
                endDateEpoch: epochFromDateTime(date: endDate),
                id: getResultId(createSprint.results!),
                startDateEpoch: epochFromDateTime(date: startDate),
              ),
              errorCode: null,
            );
          }
        } else if (isAlreadyExisitingResponse.success &&
            isAlreadyExisitingResponse.count > 0) {
          /// If there is an existing sprint with this date. Throw error.
          throw APIErrorResponse(
            message: 'There is an existing sprint with this date already!',
            errorCode: null,
          );
        }
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<DSRRecord>> updateDSREntries({
    required String dsrId,
    required String column,
    required List<DSRWorkTrack> dsrworkTrack,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        /// Check first if the project ids does exist from the database.
        final bool isExistProjectIds = await doesProjectIdExist(
          dsrRecords: dsrworkTrack,
        );

        if (!columnsEntries.contains(column)) {
          throw APIErrorResponse(
            message:
                'Column $column does not match to the specified fields. It must be either $columnsEntries',
            errorCode: null,
          );
        }
        if (isExistProjectIds) {
          final ParseObject dsrs = ParseObject(dsrsTable);

          dsrs
            ..objectId = dsrId
            ..set<List<DSRWorkTrack>>(column, dsrworkTrack);

          final ParseResponse saveDsrResponse = await dsrs.save();

          if (saveDsrResponse.success) {
            final ParseResponse dsrInfoAfterAdding =
                await dsrs.getObject(dsrId);

            if (dsrInfoAfterAdding.success &&
                dsrInfoAfterAdding.results != null) {
              final ParseObject resultParseObject =
                  getParseObject(dsrInfoAfterAdding.results!);

              return APIResponse<DSRRecord>(
                success: true,
                message: 'Successfully added works on $column.',
                data: DSRRecord(
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
                ),
                errorCode: null,
              );
            }
          }
          throw APIErrorResponse(
            message: saveDsrResponse.error != null
                ? saveDsrResponse.error!.message
                : '',
            errorCode: null,
          );
        }
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<DSRRecord>> updateDSRWorkStatus({
    required String dsrId,
    required String status,
  }) async {
    const List<String> statuses = <String>[
      'WORKING',
      'SICK LEAVE',
      'VACATION LEAVE',
      'ABSENT',
      'HOLIDAY',
    ];
    if (!statuses.contains(status)) {
      throw APIErrorResponse(
        message:
            '$status does not match to the expected value. It must be either $statuses',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final ParseObject dsrs = ParseObject(dsrsTable);

        dsrs
          ..objectId = dsrId
          ..set<String>(dsrsStatusField, status);

        final ParseResponse saveDsrResponse = await dsrs.save();

        if (saveDsrResponse.success) {
          final ParseResponse dsrInfoAfterUpdating =
              await dsrs.getObject(dsrId);

          if (dsrInfoAfterUpdating.success &&
              dsrInfoAfterUpdating.results != null) {
            final ParseObject resultParseObject =
                getParseObject(dsrInfoAfterUpdating.results!);

            return APIResponse<DSRRecord>(
              success: true,
              message: 'Successfully update DSR record.',
              data: DSRRecord(
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
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: saveDsrResponse.error != null
              ? saveDsrResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<DSRRecord>> getAvailableDSRSForSprint({
    String? sprintId,
    String? dsrId,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final ParseObject sprints = ParseObject(dsrsTable);
        final APIResponse<SprintRecord> sprintToday =
            await sprintInfoQueryToday();

        /// Check if the sprint id exist in the database.
        if (sprintId != null) await isSprintIdExist(sprintId);

        if (dsrId != null) await isDSRIdExist(dsrId);

        final QueryBuilder<ParseObject> getAllDSRQuery =
            QueryBuilder<ParseObject>(sprints)
              ..whereEqualTo(
                dsrsSprintidField,
                sprintId ?? sprintToday.data.id,
              )
              ..whereEqualTo(dsrsUserIdField, user.objectId);
        final ParseResponse getAllDSRQueryResponse = dsrId != null
            ? await sprints.getObject(dsrId)
            : await getAllDSRQuery.query();

        if (getAllDSRQueryResponse.success) {
          final List<DSRRecord> dsrs = <DSRRecord>[];
          if (getAllDSRQueryResponse.results != null) {
            for (final ParseObject? dsr
                in getAllDSRQueryResponse.results! as List<ParseObject?>) {
              dsrs.add(
                DSRRecord(
                  id: dsr!.objectId!,
                  done: convertListDynamic(
                    dsr.get<List<dynamic>>(dsrsDoneField)!,
                  ),
                  wip:
                      convertListDynamic(dsr.get<List<dynamic>>(dsrsWipField)!),
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

          return APIListResponse<DSRRecord>(
            success: true,
            message: 'Successfully fetch dsrs.',
            data: dsrs,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: getAllDSRQueryResponse.error != null
              ? getAllDSRQueryResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }
}
