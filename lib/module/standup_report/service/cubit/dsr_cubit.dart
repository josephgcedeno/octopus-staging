import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/dsr_repository.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';

part 'dsr_state.dart';

class DSRCubit extends Cubit<DSRState> {
  DSRCubit({required this.dsrRepository}) : super(const DSRState());
  final IDSRRepository dsrRepository;

  List<DSRWorkTrack> doneList = <DSRWorkTrack>[];
  List<DSRWorkTrack> doingList = <DSRWorkTrack>[];
  List<DSRWorkTrack> blockersList = <DSRWorkTrack>[];

  ProjectStatus? currentProjectStatus;

  String dsrID = '';

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

  List<DSRWorkTrack> dsrWorkTrack(String taskLabel) {
    switch (projectStatus) {
      case ProjectStatus.done:
        doneList.add(DSRWorkTrack(text: taskLabel, projectTagId: ''));
        return doneList;
      case ProjectStatus.doing:
        doingList.add(DSRWorkTrack(text: taskLabel, projectTagId: ''));
        return doingList;
      case ProjectStatus.blockers:
        blockersList.add(DSRWorkTrack(text: taskLabel, projectTagId: ''));
        return blockersList;
      default:
        return <DSRWorkTrack>[];
    }
  }

  Future<void> updateTasks({
    required String taskLabel,
  }) async {
    try {
      // emit(const InitializeDSRLoading());

      // final APIResponse<DSRRecord> response =

      await dsrRepository.updateDSREntries(
        dsrId: dsrID,
        column: statusEnumToString(projectStatus ?? ProjectStatus.done),
        dsrworkTrack: dsrWorkTrack(taskLabel),
      );

      // initializeDSR();
      // emit(
      //   InitializeDSRSuccess(
      //     doing: response.data.wip,
      //     done: response.data.done,
      //     blockers: response.data.blockers,
      //   ),
      // );
    } catch (e) {
      // final APIErrorResponse error = e as APIErrorResponse;
      // emit(
      //   InitializeDSRFailed(
      //     errorCode: error.errorCode ?? '',
      //     message: error.message,
      //   ),
      // );
    }
  }
}
