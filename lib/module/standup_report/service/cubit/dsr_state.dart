part of 'dsr_cubit.dart';

class DSRState {
  const DSRState();
}

class FetchDatesLoading extends DSRState {
  const FetchDatesLoading();
}

class FetchDatesSuccess extends DSRState {
  const FetchDatesSuccess(this.dateString);

  final String dateString;
}

class FetchDatesFailed extends DSRState {
  const FetchDatesFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
