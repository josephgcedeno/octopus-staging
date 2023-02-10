import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/project_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProjectRepository extends IProjectRepository {
  @override
  Future<APIResponse<ProjectTag>> addProject({
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
          return APIResponse<ProjectTag>(
            success: true,
            message: 'Successfull added project',
            data: ProjectTag(
              dateEpoch: epochFromDateTime(date: date ?? DateTime.now()),
              id: getResultId(projectTagResponse.results!),
              projectName: projectName,
              status: status ?? 'ACTIVE',
              color: projectColor,
            ),
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: projectTagResponse.error != null
              ? projectTagResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> deleteProject({required String id}) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject deleteProject = ParseObject(projectTagsTable);

        final ParseResponse deleteProjectResponse =
            await deleteProject.delete(id: id);

        if (deleteProjectResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted project.',
            data: null,
            errorCode: null,
          );
        }

        throw APIErrorResponse(
          message: deleteProjectResponse.error != null
              ? deleteProjectResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<ProjectTag>> getAllProjects({
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

        return APIListResponse<ProjectTag>(
          success: true,
          message: 'Successfully get all projects.',
          data: projects,
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: projectTagsResponse.error != null
            ? projectTagsResponse.error!.message
            : '',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<ProjectTag>> updateProject({
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

            return APIResponse<ProjectTag>(
              success: true,
              message: 'Successfully updated project.',
              data: ProjectTag(
                id: resultParseObject.objectId!,
                dateEpoch:
                    resultParseObject.get<int>(projectTagsProjectDateField)!,
                projectName:
                    resultParseObject.get<String>(projectTagsProjectNameField)!,
                status: resultParseObject
                    .get<String>(projectTagsProjectStatusField)!,
                color: resultParseObject
                    .get<String>(projectTagsProjectColorField)!,
              ),
              errorCode: null,
            );
          }
        }

        throw APIErrorResponse(
          message: updateProjectTagResponse.error != null
              ? updateProjectTagResponse.error!.message
              : '',
          errorCode: null,
        );
      }

      throw APIErrorResponse(
        message: 'Something went wrong',
        errorCode: null,
      );
    } on SocketException {
      throw APIResponse.socketErrorResponse();
    }
  }
}
