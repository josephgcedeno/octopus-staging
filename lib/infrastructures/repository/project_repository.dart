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
  Future<APIResponse<Project>> addProject({
    required String projectName,
    required String projectColor,
    String? status,
    DateTime? date,
  }) async {
    if (projectName.isEmpty ||
        projectColor.isEmpty ||
        (status != null && status.isEmpty)) {
      throw APIErrorResponse(
        message: 'This fields cannot be empty.',
        errorCode: null,
      );
    }
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
          return APIResponse<Project>(
            success: true,
            message: 'Successfull added project',
            data: Project(
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
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<void>> deleteProject({required String id}) async {
    if (id.isEmpty) {
      throw APIErrorResponse(
        message: 'ID cannot be empty.',
        errorCode: null,
      );
    }
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
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIListResponse<Project>> getAllProjects({
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  }) async {
    if ((projectName != null && projectName.isEmpty) ||
        (projectColor != null && projectColor.isEmpty) ||
        (status != null && status.isEmpty)) {
      throw APIErrorResponse(
        message: 'These fields cannot be empty.',
        errorCode: null,
      );
    }
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
        final List<Project> projects = <Project>[];
        if (projectTagsResponse.results != null) {
          for (final ParseObject project
              in projectTagsResponse.results! as List<ParseObject>) {
            projects.add(
              Project(
                id: project.objectId!,
                projectName: project.get<String>(projectTagsProjectNameField)!,
                dateEpoch: project.get<int>(projectTagsProjectDateField)!,
                status: project.get<String>(projectTagsProjectStatusField)!,
                color: project.get<String>(projectTagsProjectColorField)!,
              ),
            );
          }
        }

        return APIListResponse<Project>(
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
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<Project>> updateProject({
    required String id,
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  }) async {
    if (id.isEmpty ||
        (projectName != null && projectName.isEmpty) ||
        (projectColor != null && projectColor.isEmpty) ||
        (status != null && status.isEmpty)) {
      throw APIErrorResponse(
        message: 'These fields cannot be empty.',
        errorCode: null,
      );
    }
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final ParseObject updateProject = ParseObject(projectTagsTable);

        updateProject.objectId = id;

        if (projectName != null) {
          updateProject.set<String>(
            projectTagsProjectNameField,
            projectName,
          );
        }
        if (status != null) {
          updateProject.set<String>(projectTagsProjectStatusField, status);
        }
        if (date != null) {
          updateProject.set<int>(
            projectTagsProjectDateField,
            epochFromDateTime(date: date),
          );
        }
        if (projectColor != null) {
          updateProject.set<String>(
            projectTagsProjectColorField,
            projectColor,
          );
        }

        final ParseResponse updateProjectResponse =
            await updateProject.save();

        if (updateProjectResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId =
              getResultId(updateProjectResponse.results!);

          final ParseResponse projectResponse =
              await updateProject.getObject(objectId);

          if (projectResponse.success && projectResponse.results != null) {
            final ParseObject resultParseObject =
                getParseObject(projectResponse.results!);

            return APIResponse<Project>(
              success: true,
              message: 'Successfully updated project.',
              data: Project(
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
          message: updateProjectResponse.error != null
              ? updateProjectResponse.error!.message
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
