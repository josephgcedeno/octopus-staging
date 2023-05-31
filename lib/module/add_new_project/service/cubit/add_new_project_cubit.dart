import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/project_repository.dart';

part 'add_new_project_state.dart';

class AddNewProjectCubit extends Cubit<AddNewProjectState> {
  AddNewProjectCubit({required this.projectRepository})
      : super(AddNewProjectInitial());
  final IProjectRepository projectRepository;

  Future<void> addNewProject({
    required String projectName,
    required String projectColor,
    required String logoImage,
  }) async {
    try {
      emit(AddNewProjectLoading());

      await projectRepository.addProject(
        logoImage: logoImage,
        projectColor: projectColor,
        projectName: projectName,
      );

      emit(AddNewProjectSuccess());
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        AddNewProjectFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
