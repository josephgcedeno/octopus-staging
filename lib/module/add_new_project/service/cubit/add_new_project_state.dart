part of 'add_new_project_cubit.dart';

class AddNewProjectState {
  const AddNewProjectState();
}

class AddNewProjectInitial extends AddNewProjectState {}

class AddNewProjectLoading extends AddNewProjectState {}

class AddNewProjectSuccess extends AddNewProjectState {}

class AddNewProjectFailed extends AddNewProjectState {
  AddNewProjectFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
