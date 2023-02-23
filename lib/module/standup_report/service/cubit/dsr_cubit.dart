import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';
import 'package:octopus/infrastructures/repository/interfaces/project_repository.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/service/cubit/task_card_dto.dart';

part 'dsr_state.dart';

class DSRCubit extends Cubit<DSRState> {
  DSRCubit({required this.dsrRepository, required this.projectRepository})
      : super(const DSRState());
  final IDSRRepository dsrRepository;
  final IProjectRepository projectRepository;

  List<Task> doneList = <Task>[];
  List<Task> doingList = <Task>[];
  List<Task> blockersList = <Task>[];

  ProjectStatus? currentProjectStatus;

  String dsrID = '';
  String projectTagId = '';

  ProjectStatus? get projectStatus {
    return currentProjectStatus;
  }

  set projectStatus(ProjectStatus? status) {
    currentProjectStatus = status;
    emit(const HideStatusPane());
    emit(UpdateTaskStatus(toBeginningOfSentenceCase(status!.name) ?? ''));
  }

  void toggleStatusPane({required bool isVisible}) {
    if (isVisible) {
      emit(const ShowStatusPane());
    } else {
      emit(const HideStatusPane());
    }
  }

  void toggleProjectPane({required bool isVisible}) {
    if (isVisible) {
      emit(const ShowProjectPane());
    } else {
      emit(const HideProjectPane());
    }
  }

  Future<void> fetchCurrentDate() async {
    try {
      emit(const FetchDatesLoading());

      final APIResponse<SprintRecord> response =
          await dsrRepository.sprintInfoQueryToday();

      final DateFormat dateFormat = DateFormat('MMM dd');

      final DateTime now = DateTime.now();
      final double days =
          (response.data.endDateEpoch - now.millisecondsSinceEpoch) / 86400000;

      final String startDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(response.data.startDateEpoch),
      );
      final String endDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(response.data.endDateEpoch),
      );

      // FIXME: Account for how many actual days there are in a sprint. Should weekend count or not?
      final int remaining = 14 - days.ceil();
      emit(FetchDatesSuccess('$startDate - $endDate > Day $remaining of 14'));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchDatesFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  Future<void> initializeDSR() async {
    try {
      emit(const InitializeDSRLoading());

      final APIResponse<DSRRecord> response =
          await dsrRepository.initializeDSR();
      dsrID = response.data.id;
      doneList = response.data.done;
      doingList = response.data.wip;
      blockersList = response.data.blockers;
      emit(
        InitializeDSRSuccess(
          doing: response.data.wip,
          done: response.data.done,
          blockers: response.data.blockers,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        InitializeDSRFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  /// FIXME: Implement add sprint on admin module
  Future<void> addSprint() async {
    // try {
    await dsrRepository.addSprint(
      startDate: DateTime(2023, 2, 13),
      endDate: DateTime(2023, 2, 24),
    );
    // } catch (e) {}
  }

  String statusEnumToString(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.done:
        return 'done';
      case ProjectStatus.doing:
        return 'work_in_progress';
      case ProjectStatus.blockers:
        return 'blockers';
    }
  }

  String statusIntToString(int status) {
    switch (status) {
      case 0:
        return 'done';
      case 1:
        return 'work_in_progress';
      case 2:
        return 'blockers';
      default:
        return '';
    }
  }

  ProjectStatus statusIntToEnum(int status) {
    switch (status) {
      case 0:
        return ProjectStatus.done;
      case 1:
        return ProjectStatus.doing;
      case 2:
        return ProjectStatus.blockers;
      default:
        return ProjectStatus.done;
    }
  }

  List<Task> addTaskLocally(String taskLabel) {
    switch (projectStatus) {
      case ProjectStatus.done:
        doneList.add(Task(text: taskLabel, projectTagId: projectTagId));
        return doneList;
      case ProjectStatus.doing:
        doingList.add(Task(text: taskLabel, projectTagId: projectTagId));
        return doingList;
      case ProjectStatus.blockers:
        blockersList.add(Task(text: taskLabel, projectTagId: projectTagId));
        return blockersList;
      default:
        return <Task>[];
    }
  }

  Future<void> updateTasks({
    required String taskLabel,
  }) async {
    try {
      emit(
        UpdateTaskLoading(
          status: projectStatus ?? ProjectStatus.done,
          taskLabel: taskLabel,
          projectTagId: projectTagId,
        ),
      );
      await dsrRepository.updateDSREntries(
        dsrId: dsrID,
        column: statusEnumToString(projectStatus ?? ProjectStatus.done),
        tasks: addTaskLocally(taskLabel),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        UpdateTaskFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  Future<void> deleteTask(TaskCardDTO task) async {
    try {
      List<Task> taskList = <Task>[];
      switch (task.status) {
        case 0:
          taskList = doneList;
          break;
        case 1:
          taskList = doingList;
          break;
        case 2:
          taskList = blockersList;
          break;
      }

      for (int i = 0; i < taskList.length; i++) {
        if (taskList[i].projectTagId == task.projectId &&
            taskList[i].text == task.taskName) {
          taskList.removeAt(i);
          break;
        }
      }
      emit(
        InitializeDSRSuccess(
          doing: doingList,
          done: doneList,
          blockers: blockersList,
        ),
      );
      await dsrRepository.updateDSREntries(
        dsrId: dsrID,
        column: statusIntToString(task.status),
        tasks: taskList,
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        InitializeDSRFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  void editTask({
    required TaskCardDTO oldTask,
    required TaskCardDTO updatedTask,
  }) {
    updateTasks(taskLabel: updatedTask.taskName);
    deleteTask(oldTask);
  }

  Future<void> getAllProjects() async {
    try {
      final APIListResponse<Project> response =
          await projectRepository.getAllProjects(status: 'ACTIVE');

      emit(FetchProjectsSuccess(projects: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchProjectsFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }

  void setProject(Project tag) {
    projectTagId = tag.id;
    emit(const HideProjectPane());
    emit(SetProjectSuccess(project: tag));
  }
}
