import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:octopus/infrastructures/models/api_error_response.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/repository/interfaces/pdf_repository.dart';
import 'package:octopus/internal/database_strings.dart';
import 'package:octopus/internal/error_message_string.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class PDFRepository implements IPDFRepository {
  final String _generatePdfUrl = '/generate-pdf';
  late final String _baseUrlApi = dotenv.get('STAGING_PARSE_SERVER_API');

  @override
  Future<APIResponse<Uint8List>> generateHistoricalReport({
    required String title,
    required String dateReport,
    List<EmployeeDailyTimeRecord>? employeeAttendances,
    List<UserDSR>? userDsr,
    List<UserLeaveRequest>? userLeaveRequests,
    String? leaveType,
  }) async {
    try {
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        late final String generateReportUrlPath;
        final Map<String, dynamic> jsonBody = <String, dynamic>{
          'date_report': dateReport,
          'title': title,
        };

        if (employeeAttendances != null) {
          generateReportUrlPath = 'attendances-report';
          jsonBody['attendaces'] = employeeAttendances;
        } else if (userDsr != null) {
          generateReportUrlPath = 'dsr-report';
          jsonBody['dsrs'] = userDsr;
        } else if (userLeaveRequests != null) {
          generateReportUrlPath = 'leave-requests-report';
          jsonBody['leave_requests'] = userLeaveRequests;
          jsonBody['leave_tyoe'] = leaveType;
        }

        final http.Response response = await http.post(
          Uri.http(
            _baseUrlApi,
            '$_generatePdfUrl/$generateReportUrlPath',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              'sessionToken': '8e022397-25d9-4178-92e9-1e3a1574071f',
              'data': jsonEncode(jsonBody),
            },
          ),
        );

        if (response.statusCode == 200) {
          return APIResponse<Uint8List>(
            success: true,
            message: 'Successfully Fetch PDF',
            errorCode: null,
            data: response.bodyBytes,
          );
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }

  @override
  Future<APIResponse<Uint8List>> generatePDF({
    required String name,
    required Map<String, List<String>> selectedTasks,
  }) async {
    try {
      if (name.isEmpty || selectedTasks.isEmpty) {
        throw APIErrorResponse(message: errorEmptyValue, errorCode: null);
      }
      final ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null && user.get<bool>(usersIsAdminField)!) {
        final http.Response response = await http.post(
          Uri.https(
            _baseUrlApi,
            '$_generatePdfUrl/daily-accomplishment-report',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              'sessionToken': '8e022397-25d9-4178-92e9-1e3a1574071f',
              'selectedTasks': selectedTasks,
              'name': name,
            },
          ),
        );
        // Check if response is error
        if (response.statusCode == 200) {
          return APIResponse<Uint8List>(
            success: true,
            message: 'Successfully Fetch PDF',
            errorCode: null,
            data: response.bodyBytes,
          );
        }
      }

      String errorMessage = errorSomethingWentWrong;
      if (user != null && !user.get<bool>(usersIsAdminField)!) {
        errorMessage = errorInvalidPermission;
      }
      throw APIErrorResponse(
        message: errorMessage,
        errorCode: null,
      );
    } on SocketException {
      throw APIErrorResponse.socketErrorResponse();
    }
  }
}
