import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/infrastructures/repository/dsr_repository.dart';
import 'package:octopus/infrastructures/repository/project_repository.dart';
import 'package:octopus/internal/string_status.dart';

part 'accomplishments_state.dart';

class AccomplishmentsCubit extends Cubit<AccomplishmentsState> {
  AccomplishmentsCubit({
    required this.projectRepository,
    required this.dsrRepository,
  }) : super(AccomplishmentsState());
  final ProjectRepository projectRepository;
  final DSRRepository dsrRepository;

  void getSelectedTasks(Map<String, List<DSRWorks>> selectedTasks) =>
      emit(AccomplishmentsState(selectedTasks: selectedTasks));

  Future<void> getAccomplishments(DateTime date, int projectIndex) async {
    try {
      emit(FetchAllAccomplishmentsDataLoading());

      final DateTime formattedDate = DateTime(date.year, date.month, date.day);
      final DateTime today = DateTime.now();
      final DateTime formattedToday =
          DateTime(today.year, today.month, today.day);

      final APIResponse<SprintRecord> todaySprintResponse =
          await dsrRepository.sprintInfoQueryToday();
      String sprintId = todaySprintResponse.data.id;

      final APIListResponse<Project> allProjectResponse =
          await projectRepository.getAllProjects(status: active);
      final List<Project> projects = allProjectResponse.data;

      final APIListResponse<SprintRecord> allSprintResponse =
          await dsrRepository.getAllSprints();
      final List<SprintRecord> sprints = allSprintResponse.data;

      final int epoch = date.millisecondsSinceEpoch ~/ 1000;
      final String projectId = allProjectResponse.data[projectIndex].id;

      if (formattedDate.isAtSameMomentAs(formattedToday)) {
        sprints.map((SprintRecord sprint) {
          if (sprint.startDateEpoch < epoch && sprint.endDateEpoch < epoch) {
            sprintId = sprint.id;
          }
        }).toList();
      }

      final APIResponse<AllDSRItem> accomplishments =
          await dsrRepository.getAllDSRRecordForSprint(
        sprintId: sprintId,
        projectId: projectId,
        startDate: formattedDate,
        endDate: formattedDate,
      );

      emit(
        FetchAllAccomplishmentsDataSuccess(
          tasks: accomplishments.data.data,
          projects: projects,
        ),
      );
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;

      emit(
        FetchAllAccomplishmentsDataFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
