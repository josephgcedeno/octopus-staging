import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';

abstract class IProjectRepository {
  /// This function will simply get all the available projects from the database.
  /// This object will contain the necessary field for Leave record.
  Future<APIListResponse<ProjectTag>> getAllProjects({
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will update the project information such as project name, color, status and date.
  ///
  /// [id] this determines which project to be updated.
  ///
  /// [projectName] this updates project name.
  ///
  /// [projectColor] this updates project color.
  ///
  /// [status] this updates the status if active or inactive.
  ///
  /// [date] this updates the date of the project.
  /// This object will contain the necessary field for Leave record.
  Future<APIResponse<ProjectTag>> updateProject({
    required String id,
    String? projectName,
    String? projectColor,
    String? status,
    DateTime? date,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will delete certain project.
  ///
  /// [id] this determines which project to be deleted.
  /// This object will contain the necessary field for Leave record.
  Future<APIResponse<void>> deleteProject({
    required String id,
  });

  /// FOR: ADMIN USE ONLY
  ///
  /// This function will add a project to the database.
  ///
  /// [projectName] this defines the name of the project.
  ///
  /// [projectColor] this defines the color of the project.
  ///
  /// [status] this defines the status of the project if active or not.
  ///
  /// [date] this defines the date created of the project.
  /// This object will contain the necessary field for Leave record.
  Future<APIResponse<ProjectTag>> addProject({
    required String projectName,
    required String projectColor,
    String? status,
    DateTime? date,
  });
}
