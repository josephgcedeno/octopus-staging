class APIErrorResponse {
  APIErrorResponse({
    required this.message,
    required this.errorCode,
  });

  factory APIErrorResponse.socketErrorResponse() => APIErrorResponse(
        errorCode: 'NO_INTERNET_CONNECTION',
        message: 'No Internet Connection',
      );

  /// base API response
  final String message;
  final String? errorCode;
}
