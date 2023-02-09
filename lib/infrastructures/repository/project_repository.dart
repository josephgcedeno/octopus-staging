import 'dart:io';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/project_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProjectRepository extends IProjectRepository {
  @override
  Future<ProjectTagResponse> addProject({
    required String projectName,
    required String projectColor,
    String? status,
    DateTime? date,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject projectTag = ParseObject(projectTagsTable)
          ..set<String>(projectTagsProjectNameField, projectName)
          ..set<String>(projectTagsProjectColorField, projectColor)
          ..set<String>(
            projectTagsProjectStatusField,
            status ?? 'ACTIVE',
          )
          ..set<int>(
            projectTagsProjectDateField,
            epochFromDateTime(
              date: date ?? DateTime.now(),
            ),
          );

        final ParseResponse projectTagResponse = await projectTag.save();
        if (projectTagResponse.success) {
          return ProjectTagResponse(
            projects: <ProjectTag>[
              ProjectTag(
                dateEpoch: epochFromDateTime(date: date ?? DateTime.now()),
                id: getResultId(projectTagResponse.results!),
                projectName: projectName,
                status: status ?? 'ACTIVE',
                color: projectColor,
              ),
            ],
            status: 'success',
          );
        }

        throw APIResponse<void>(
          success: false,
          message: projectTagResponse.error != null
              ? projectTagResponse.error!.message
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
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<ProjectTagResponse> deleteProject({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject deleteProject = ParseObject(projectTagsTable);

        final ParseResponse deleteProjectResponse =
            await deleteProject.delete(id: id);

        if (deleteProjectResponse.success) {
          return ProjectTagResponse(
            projects: <ProjectTag>[],
            status: 'success',
          );
        }

        throw APIResponse<void>(
          success: false,
          message: deleteProjectResponse.error != null
              ? deleteProjectResponse.error!.message
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
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<ProjectTagResponse> getAllProjects({
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  }) async {
    try {
      final QueryBuilder<ParseObject> projectTags =
          QueryBuilder<ParseObject>(ParseObject(projectTagsTable));

      if (projectName != null) {
        projectTags.whereContains(projectTagsProjectNameField, projectName);
      }
      if (status != null) {
        projectTags.whereEqualTo(projectTagsProjectStatusField, status);
      }
      if (date != null) {
        projectTags.whereEqualTo(
          projectTagsProjectDateField,
          epochFromDateTime(date: date),
        );
      }
      if (projectColor != null) {
        projectTags.whereEqualTo(projectTagsProjectColorField, projectColor);
      }

      final ParseResponse projectTagsResponse = await projectTags.query();
      if (projectTagsResponse.success) {
        final List<ProjectTag> projects = <ProjectTag>[];
        if (projectTagsResponse.results != null) {
          for (final ParseObject project
              in projectTagsResponse.results! as List<ParseObject>) {
            projects.add(
              ProjectTag(
                id: project.objectId!,
                projectName: project.get<String>(projectTagsProjectNameField)!,
                dateEpoch: project.get<int>(projectTagsProjectDateField)!,
                status: project.get<String>(projectTagsProjectStatusField)!,
                color: project.get<String>(projectTagsProjectColorField)!,
              ),
            );
          }
        }

        return ProjectTagResponse(
          projects: projects,
          status: 'success',
        );
      }

      throw APIResponse<void>(
        success: false,
        message: projectTagsResponse.error != null
            ? projectTagsResponse.error!.message
            : '',
        data: null,
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<ProjectTagResponse> updateProject({
    required String id,
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject updateProjectTag = ParseObject(projectTagsTable);

        updateProjectTag.objectId = id;

        if (projectName != null) {
          updateProjectTag.set<String>(
            projectTagsProjectNameField,
            projectName,
          );
        }
        if (status != null) {
          updateProjectTag.set<String>(projectTagsProjectStatusField, status);
        }
        if (date != null) {
          updateProjectTag.set<int>(
            projectTagsProjectDateField,
            epochFromDateTime(date: date),
          );
        }
        if (projectColor != null) {
          updateProjectTag.set<String>(
            projectTagsProjectColorField,
            projectColor,
          );
        }

        final ParseResponse updateProjectTagResponse =
            await updateProjectTag.save();

        if (updateProjectTagResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId =
              getResultId(updateProjectTagResponse.results!);

          final ParseResponse projectResponse =
              await updateProjectTag.getObject(objectId);

          if (projectResponse.success && projectResponse.results != null) {
            final ParseObject resultParseObject =
                getParseObject(projectResponse.results!);

            return ProjectTagResponse(
              projects: <ProjectTag>[
                ProjectTag(
                  id: resultParseObject.objectId!,
                  dateEpoch:
                      resultParseObject.get<int>(projectTagsProjectDateField)!,
                  projectName: resultParseObject
                      .get<String>(projectTagsProjectNameField)!,
                  status: resultParseObject
                      .get<String>(projectTagsProjectStatusField)!,
                  color: resultParseObject
                      .get<String>(projectTagsProjectColorField)!,
                ),
              ],
              status: 'success',
            );
          }
        }

        throw APIResponse<void>(
          success: false,
          message: updateProjectTagResponse.error != null
              ? updateProjectTagResponse.error!.message
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
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }
}
