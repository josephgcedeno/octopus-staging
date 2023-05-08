import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/hr_repository.dart';

part 'hr_state.dart';

class HrCubit extends Cubit<HrState> {
  HrCubit({required this.hrRepository}) : super(HrInitial());
  final IHRRepository hrRepository;

  Future<void> fetchAllCredentials({
    String? id,
    String? accountType,
  }) async {
    try {
      emit(FetchAllCredentialsLoading());

      final APIListResponse<Credential> response =
          await hrRepository.getAllCredentials(
        id: id,
        accountType: accountType,
      );

      emit(FetchAllCredentialsSuccess(credential: response.data));
    } catch (e) {
      final APIErrorResponse error = e as APIErrorResponse;
      emit(
        FetchAllCredentialsFailed(
          errorCode: error.errorCode ?? '',
          message: error.message,
        ),
      );
    }
  }
}
