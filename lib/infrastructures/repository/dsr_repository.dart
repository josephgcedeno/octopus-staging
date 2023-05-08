import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class DSRRepository extends IDSRRepository {
  final DateTime today = DateTime.now();

  /// This list down the available column to update the entries (done, work_in_progress, and blockers)
  List<String> get columnsEntries => const <String>[
        DSRsParseObject.keyDone,
        DSRsParseObject.keyWIP,
        DSRsParseObject.keyBlockers,
      ];

  DateTime get currentDate => DateTime(today.year, today.month, today.day);

  Future<List<DSRWorks>> manageData({
    required List<dynamic> tasks,
    required String userName,
    required String date,
    required List<ProjectsParseObject> projects,
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

      final ProjectsParseObject project = projects.firstWhere(
        (ProjectsParseObject obj) => obj.objectId == projectTagId,
      );

      final String projectName = project.name;
      final String projectColor = project.color;

      data.add(
        DSRWorks(
          tagId: projectTagId,
          text: text,
          user: userName,
          projectName: projectName,
          date: date,
          color: projectColor,
        ),
      );
    }
    return data;
  }

  /// This will check if the sprint id does exist in the database.
  Future<bool> isSprintIdExist(String sprintId) async {
    final SprintsParseObject dsrs = SprintsParseObject();
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
    final DSRsParseObject dsrs = DSRsParseObject();
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
    final QueryBuilder<ParseUser> queryGetUserId = QueryBuilder<ParseUser>(
      ParseUser.forQuery(),
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
            ? queryGetUserIdResponse.error?.code.toString()
            : '',
      );
    }
    return true;
  }

  /// This will check if the project ID/s does exist. It will only take either between multiple project id or single project id.
  ///
  /// [tasks] this will be use to check multiple project ids.
  ///
  /// [projectId] this will check if the project id is exis
  Future<bool> doesProjectIdExist({
    List<Task>? tasks,
    String? projectId,
  }) async {
    final ProjectsParseObject project = ProjectsParseObject();
    if (tasks != null) {
      final QueryBuilder<ProjectsParseObject> queryGetActiveProject =
          QueryBuilder<ProjectsParseObject>(
        project,
      )
            ..whereEqualTo(ProjectsParseObject.keyStatus, active)
            ..keysToReturn(<String>['objectId']);

      final ParseResponse queryGetActiveProjetResponse =
          await queryGetActiveProject.query();

      if (queryGetActiveProjetResponse.error != null) {
        formatAPIErrorResponse(error: queryGetActiveProjetResponse.error!);
      }

      if (queryGetActiveProjetResponse.success &&
          queryGetActiveProjetResponse.results != null) {
        final List<ParseObject> projects =
            queryGetActiveProjetResponse.results! as List<ParseObject>;
        for (final Task task in tasks) {
          if (!projects
              .any((ParseObject item) => item.objectId == task.projectTagId)) {
            throw APIErrorResponse(
              message: 'The project ${task.projectTagId} does not exist.',
              errorCode: null,
            );
          }
        }
        return true;
      }
    } else if (projectId != null) {
      final ParseResponse projectIdResponse =
          await project.getObject(projectId);

      if (projectIdResponse.error != null) {
        formatAPIErrorResponse(error: projectIdResponse.error!);
      }

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
      DSRsParseObject.keyDone,
      DSRsParseObject.keyWIP,
      DSRsParseObject.keyBlockers,
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
          final DSRsParseObject dsrs = DSRsParseObject();
          final DateTime now = DateTime.now();
          final int date =
              epochFromDateTime(date: DateTime(now.year, now.month, now.day));

          final QueryBuilder<DSRsParseObject> dsrQuery =
              QueryBuilder<DSRsParseObject>(
            dsrs,
          )
                ..whereEqualTo(
                  DSRsParseObject.keySprint,
                  SprintsParseObject()..objectId = sprintId,
                )
                ..whereGreaterThanOrEqualsTo(
                  DSRsParseObject.keyDate,
                  startDate != null && endDate != null
                      ? epochFromDateTime(date: startDate)
                      : date,

                  /// If no date range specified, then this Query will return the record of today's sprint.
                )
                ..whereLessThan(
                  DSRsParseObject.keyDate,
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
                ..keysToReturn(
                  <String>[
                    DSRsParseObject.keyUser,
                    DSRsParseObject.keySprint,
                    DSRsParseObject.keyDate,
                    ...columns,
                  ],
                )
                ..includeObject(
                  <String>[
                    DSRsParseObject.keyUser,
                  ],
                )
                ..orderByAscending(DSRsParseObject.keyDate);

          /// If specified user id. Just query certain user.
          if (userId != null) {
            final bool isUserExist = await isUserIdExist(userId);
            dsrQuery.whereEqualTo(
              DSRsParseObject.keyUser,
              isUserExist ? (ParseUser.forQuery()..objectId = userId) : '',
            );
          }

          /// Check if filter by project id does exist.
          if (projectId != null) await doesProjectIdExist(projectId: projectId);

          final ParseResponse dsrResponse = await dsrQuery.query();

          if (dsrResponse.error != null) {
            formatAPIErrorResponse(error: dsrResponse.error!);
          }

          final Map<String, List<DSRWorks>> datas = <String, List<DSRWorks>>{};

          /// Get all user info list parse object.
          final ParseResponse allUsersInfo =
              await EmployeeInfoParseObject().getAll();

          /// Get all project info list of parse object.
          final ParseResponse allProjects =
              await ProjectsParseObject().getAll();

          final List<EmployeeInfoParseObject> allUserInfoCasted =
              List<EmployeeInfoParseObject>.from(
            allUsersInfo.results ?? <dynamic>[],
          );

          final List<ProjectsParseObject> allProjectInfoCasted =
              List<ProjectsParseObject>.from(
            allProjects.results ?? <dynamic>[],
          );

          if (dsrResponse.success) {
            if (dsrResponse.results != null) {
              for (final ParseObject dsrDonePerUser
                  in dsrResponse.results! as List<ParseObject>) {
                final DSRsParseObject row =
                    DSRsParseObject.toCustomParseObject(data: dsrDonePerUser);

                final EmployeeInfoParseObject singleEmployeeInfo =
                    allUserInfoCasted.firstWhere(
                  (EmployeeInfoParseObject obj) =>
                      obj.user.objectId == row.user.objectId,
                );

                final String userName =
                    '${singleEmployeeInfo.firstName} ${singleEmployeeInfo.lastName}';

                final String date = DateFormat('EEE, MMM d, yyyy').format(
                  dateTimeFromEpoch(
                    epoch: row.date,
                  ),
                );

                for (final String column in columns) {
                  final List<dynamic> tasks = row.get(column)!;

                  if (datas.containsKey(column)) {
                    datas[column]!.addAll(
                      await manageData(
                        tasks: tasks,
                        userName: userName,
                        filterByProjectId: projectId,
                        date: date,
                        projects: allProjectInfoCasted,
                      ),
                    );
                    continue;
                  }

                  datas[column] = await manageData(
                    tasks: tasks,
                    userName: userName,
                    filterByProjectId: projectId,
                    date: date,
                    projects: allProjectInfoCasted,
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
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }

      throw APIErrorResponse(
        message: errorMessage,
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
        final SprintsParseObject sprint = SprintsParseObject();

        final QueryBuilder<SprintsParseObject> sprintRecord =
            QueryBuilder<SprintsParseObject>(sprint)
              ..orderByAscending('createdAt');

        if (startDate != null && endDate != null) {
          /// Query the start date and end date.
          final DateTime endDateToQuery =
              DateTime(endDate.year, endDate.month, endDate.day + 1);
          sprintRecord
            ..whereGreaterThanOrEqualsTo(
              SprintsParseObject.keyStartDate,
              epochFromDateTime(date: startDate),
            )
            ..whereLessThan(
              SprintsParseObject.keyEndDate,
              epochFromDateTime(date: endDateToQuery),
            );
        }

        final ParseResponse sprintResponse = await sprintRecord.query();

        if (sprintResponse.error != null) {
          formatAPIErrorResponse(error: sprintResponse.error!);
        }

        if (sprintResponse.success) {
          final List<SprintRecord> sprints = <SprintRecord>[];
          if (sprintResponse.results != null) {
            for (final ParseObject result
                in sprintResponse.results! as List<ParseObject>) {
              final SprintsParseObject sprintRecord =
                  SprintsParseObject.toCustomParseObject(data: result);
              sprints.add(
                SprintRecord(
                  id: sprintRecord.objectId!,
                  startDateEpoch: sprintRecord.startDate,
                  endDateEpoch: sprintRecord.endDate,
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
      }
      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
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

      final QueryBuilder<SprintsParseObject> todayRecord =
          QueryBuilder<SprintsParseObject>(SprintsParseObject())
            ..whereGreaterThanOrEqualsTo(
              SprintsParseObject.keyEndDate,
              fromDateTimeToEpoch,
            )
            ..whereLessThanOrEqualTo(
              SprintsParseObject.keyStartDate,
              fromDateTimeToEpoch,
            );

      final ParseResponse queryTodayRecord = await todayRecord.query();

      if (queryTodayRecord.error != null) {
        formatAPIErrorResponse(error: queryTodayRecord.error!);
      }

      final SprintsParseObject sprintInfo =
          SprintsParseObject.toCustomParseObject(
        data: queryTodayRecord.results!.first,
      );

      return APIResponse<SprintRecord>(
        success: true,
        message: 'Successfully get the sprint record for this day.',
        data: SprintRecord(
          id: sprintInfo.objectId!,
          startDateEpoch: sprintInfo.startDate,
          endDateEpoch: sprintInfo.endDate,
        ),
        errorCode: null,
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
        final DSRsParseObject dsrs = DSRsParseObject();

        final APIResponse<SprintRecord> sprintInfo =
            await sprintInfoQueryToday();

        if (sprintInfo.success) {
          final String sprintId = sprintInfo.data.id;
          final String userId = user.objectId!;
          const String workStatus = 'ABSENT';

          final int epochDateToday = epochFromDateTime(date: currentDate);

          /// Check if there is an exsiting dsr record
          final QueryBuilder<DSRsParseObject> isAlreadyExisiting =
              QueryBuilder<DSRsParseObject>(dsrs)
                ..whereEqualTo(
                  DSRsParseObject.keySprint,
                  SprintsParseObject()..objectId = sprintId,
                )
                ..whereEqualTo(
                  DSRsParseObject.keyUser,
                  ParseUser.forQuery()..objectId = userId,
                )
                ..whereEqualTo(DSRsParseObject.keyDate, epochDateToday);

          final ParseResponse isAlreadyExisitingResponse =
              await isAlreadyExisiting.query();

          if (isAlreadyExisitingResponse.error != null) {
            formatAPIErrorResponse(error: isAlreadyExisitingResponse.error!);
          }

          /// If count is 0 create dsr record
          if (isAlreadyExisitingResponse.success &&
              isAlreadyExisitingResponse.count == 0) {
            dsrs.sprints = SprintsParseObject()..objectId = sprintId;
            dsrs.user = ParseUser.forQuery()..objectId = userId;
            dsrs.date = epochDateToday;
            dsrs.done = <Task>[];
            dsrs.wip = <Task>[];
            dsrs.blockers = <Task>[];
            dsrs.status = workStatus;

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
                  done: <Task>[],
                  wip: <Task>[],
                  blockers: <Task>[],
                  status: workStatus,
                ),
                errorCode: null,
              );
            }
          } else if (isAlreadyExisitingResponse.success &&
              isAlreadyExisitingResponse.count == 1) {
            /// If there is an existing sprint with this date. Return the info.
            final DSRsParseObject resultParseObject =
                DSRsParseObject.toCustomParseObject(
              data: isAlreadyExisitingResponse.results!.first,
            );

            return APIResponse<DSRRecord>(
              success: true,
              message: 'There is an already record for today.',
              data: DSRRecord(
                id: resultParseObject.objectId!,
                sprintId: resultParseObject.sprints.objectId!,
                done: resultParseObject.done!,
                wip: resultParseObject.wip!,
                blockers: resultParseObject.blockers!,
                dateEpoch: resultParseObject.date,
                status: workStatus,
              ),
              errorCode: null,
            );
          }
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

        final SprintsParseObject sprints = SprintsParseObject();
        final QueryBuilder<SprintsParseObject> isAlreadyExisiting =
            QueryBuilder<SprintsParseObject>(sprints)
              ..whereEqualTo(
                SprintsParseObject.keyStartDate,
                epochFromDateTime(date: startDate),
              )
              ..whereEqualTo(
                SprintsParseObject.keyEndDate,
                epochFromDateTime(date: endDate),
              );

        final ParseResponse isAlreadyExisitingResponse =
            await isAlreadyExisiting.query();

        if (isAlreadyExisitingResponse.error != null) {
          formatAPIErrorResponse(error: isAlreadyExisitingResponse.error!);
        }

        /// If count is 0 create sprint record
        if (isAlreadyExisitingResponse.success &&
            isAlreadyExisitingResponse.count == 0) {
          sprints.startDate = epochFromDateTime(date: startDate);
          sprints.endDate = epochFromDateTime(date: endDate);

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

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
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
    required List<Task> tasks,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        /// Check first if the project ids does exist from the database.
        final bool isExistProjectIds = await doesProjectIdExist(
          tasks: tasks,
        );

        if (!columnsEntries.contains(column)) {
          throw APIErrorResponse(
            message:
                'Column $column does not match to the specified fields. It must be either $columnsEntries',
            errorCode: null,
          );
        }
        if (isExistProjectIds) {
          final DSRsParseObject dsrs = DSRsParseObject();

          dsrs
            ..objectId = dsrId
            ..set<List<Task>>(column, tasks);

          final ParseResponse saveDsrResponse = await dsrs.save();

          if (saveDsrResponse.error != null) {
            formatAPIErrorResponse(error: saveDsrResponse.error!);
          }

          if (saveDsrResponse.success) {
            final ParseResponse dsrInfoAfterAdding =
                await dsrs.getObject(dsrId);

            if (dsrInfoAfterAdding.success &&
                dsrInfoAfterAdding.results != null) {
              final DSRsParseObject resultParseObject =
                  DSRsParseObject.toCustomParseObject(
                data: dsrInfoAfterAdding.results!.first,
              );
              // getParseObject(dsrInfoAfterAdding.results!);

              return APIResponse<DSRRecord>(
                success: true,
                message: 'Successfully added works on $column.',
                data: DSRRecord(
                  id: resultParseObject.objectId!,
                  sprintId: resultParseObject.sprints.objectId!,
                  done: resultParseObject.done!,
                  wip: resultParseObject.wip!,
                  blockers: resultParseObject.blockers!,
                  status: resultParseObject.status,
                  dateEpoch: resultParseObject.date,
                ),
                errorCode: null,
              );
            }
          }
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
        final DSRsParseObject dsrs = DSRsParseObject();

        dsrs
          ..objectId = dsrId
          ..status = status;

        final ParseResponse saveDsrResponse = await dsrs.save();

        if (saveDsrResponse.error != null) {
          formatAPIErrorResponse(error: saveDsrResponse.error!);
        }

        if (saveDsrResponse.success) {
          final ParseResponse dsrInfoAfterUpdating =
              await dsrs.getObject(dsrId);

          if (dsrInfoAfterUpdating.success &&
              dsrInfoAfterUpdating.results != null) {
            final DSRsParseObject resultParseObject =
                DSRsParseObject.toCustomParseObject(
              data: dsrInfoAfterUpdating.results!.first,
            );

            return APIResponse<DSRRecord>(
              success: true,
              message: 'Successfully update DSR record.',
              data: DSRRecord(
                id: resultParseObject.objectId!,
                sprintId: resultParseObject.sprints.objectId!,
                done: resultParseObject.done!,
                wip: resultParseObject.wip!,
                blockers: resultParseObject.blockers!,
                status: resultParseObject.status,
                dateEpoch: resultParseObject.date,
              ),
              errorCode: null,
            );
          }
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
  Future<APIListResponse<DSRRecord>> getAvailableDSRSForSprint({
    String? sprintId,
    String? dsrId,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final DSRsParseObject dsrs = DSRsParseObject();
        final APIResponse<SprintRecord> sprintToday =
            await sprintInfoQueryToday();

        /// Check if the sprint id exist in the database.
        if (sprintId != null) await isSprintIdExist(sprintId);

        if (dsrId != null) await isDSRIdExist(dsrId);

        final QueryBuilder<DSRsParseObject> getAllDSRQuery =
            QueryBuilder<DSRsParseObject>(dsrs)
              ..whereEqualTo(
                DSRsParseObject.keySprint,
                SprintsParseObject()
                  ..objectId = sprintId ?? sprintToday.data.id,
              )
              ..whereEqualTo(
                DSRsParseObject.keyUser,
                ParseUser.forQuery()..objectId = user.objectId,
              );

        final ParseResponse getAllDSRQueryResponse = dsrId != null
            ? await dsrs.getObject(dsrId)
            : await getAllDSRQuery.query();

        if (getAllDSRQueryResponse.error != null) {
          formatAPIErrorResponse(error: getAllDSRQueryResponse.error!);
        }

        if (getAllDSRQueryResponse.success) {
          final List<DSRRecord> dsrs = <DSRRecord>[];
          if (getAllDSRQueryResponse.results != null) {
            for (final ParseObject? dsr
                in getAllDSRQueryResponse.results! as List<ParseObject?>) {
              final DSRsParseObject record =
                  DSRsParseObject.toCustomParseObject(data: dsr);
              dsrs.add(
                DSRRecord(
                  id: record.objectId!,
                  done: record.done!,
                  wip: record.wip!,
                  blockers: record.blockers!,
                  sprintId: record.sprints.objectId!,
                  dateEpoch: record.date,
                  status: record.status,
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
