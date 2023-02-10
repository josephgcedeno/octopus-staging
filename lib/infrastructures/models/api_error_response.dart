class APIErrorResponse {
  APIErrorResponse({
    required this.message,
    required this.errorCode,
  });

  static Map<String, dynamic> socketErrorResponse() {
    return <String, dynamic>{
      'success': false,
      'message': 'No Internet Connection',
      'errorCode': 'NO_INTERNET_CONNECTION',
    };
  }

  /// base API response
  final String message;
  final String? errorCode;
}
