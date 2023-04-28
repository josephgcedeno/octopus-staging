import 'dart:io';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/project_repository.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
        final ProjectsParseObject projectTag = ProjectsParseObject()
          ..name = projectName
          ..color = projectColor
          ..status = status ?? 'ACTIVE'
          ..date = epochFromDateTime(
            date: date ?? DateTime.now(),
          );

        final ParseResponse projectTagResponse = await projectTag.save();

        if (projectTagResponse.error != null) {
          formatAPIErrorResponse(error: projectTagResponse.error!);
        }

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
        final ProjectsParseObject deleteProject = ProjectsParseObject();

        final ParseResponse deleteProjectResponse =
            await deleteProject.delete(id: id);

        if (deleteProjectResponse.error != null) {
          formatAPIErrorResponse(error: deleteProjectResponse.error!);
        }

        if (deleteProjectResponse.success) {
          return APIResponse<void>(
            success: true,
            message: 'Successfully deleted project.',
            data: null,
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
      final QueryBuilder<ProjectsParseObject> projectTags =
          QueryBuilder<ProjectsParseObject>(ProjectsParseObject());

      if (projectName != null) {
        projectTags.whereContains(ProjectsParseObject.keyName, projectName);
      }
      if (status != null) {
        projectTags.whereEqualTo(ProjectsParseObject.keyStatus, status);
      }
      if (date != null) {
        projectTags.whereEqualTo(
          ProjectsParseObject.keyDate,
          epochFromDateTime(date: date),
        );
      }
      if (projectColor != null) {
        projectTags.whereEqualTo(ProjectsParseObject.keyColor, projectColor);
      }

      final ParseResponse projectTagsResponse = await projectTags.query();

      if (projectTagsResponse.error != null) {
        formatAPIErrorResponse(error: projectTagsResponse.error!);
      }

      final List<Project> projects = <Project>[];
      if (projectTagsResponse.results != null) {
        for (final ParseObject project
            in projectTagsResponse.results! as List<ParseObject>) {
          final ProjectsParseObject record =
              ProjectsParseObject.toCustomParseObject(data: project);

          projects.add(
            Project(
              id: record.objectId!,
              projectName: record.name,
              dateEpoch: record.date,
              status: record.status,
              color: record.color,
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
        final ProjectsParseObject updateProject = ProjectsParseObject();

        updateProject.objectId = id;

        if (projectName != null) {
          updateProject.name = projectName;
        }
        if (status != null) {
          updateProject.status = status;
        }
        if (date != null) {
          updateProject.date = epochFromDateTime(date: date);
        }
        if (projectColor != null) {
          updateProject.color = projectColor;
        }

        final ParseResponse updateProjectResponse = await updateProject.save();

        if (updateProjectResponse.error != null) {
          formatAPIErrorResponse(error: updateProjectResponse.error!);
        }

        if (updateProjectResponse.success) {
          /// Fetch the time in out record if already set. Since not available keys for time in and time out when updating, fetch manually.
          final String objectId = getResultId(updateProjectResponse.results!);

          final ParseResponse projectResponse =
              await updateProject.getObject(objectId);

          if (projectResponse.success && projectResponse.results != null) {
            final ProjectsParseObject resultParseObject =
                ProjectsParseObject.toCustomParseObject(
              data: projectResponse.results!.first,
            );

            return APIResponse<Project>(
              success: true,
              message: 'Successfully updated project.',
              data: Project(
                id: resultParseObject.objectId!,
                dateEpoch: resultParseObject.date,
                projectName: resultParseObject.name,
                status: resultParseObject.status,
                color: resultParseObject.color,
              ),
              errorCode: null,
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
}
