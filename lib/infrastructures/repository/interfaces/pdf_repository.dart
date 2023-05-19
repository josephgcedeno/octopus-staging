import 'package:flutter/services.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

abstract class IPDFRepository {
  Future<APIResponse<Uint8List>> generatePDF({
    required String name,
    required Map<String, List<String>> selectedTasks,
  });
  Future<APIResponse<Uint8List>> generateHistoricalReport({
    required String title,
    required String dateReport,
    List<EmployeeDailyTimeRecord>? employeeAttendances,
    List<UserDSR>? userDsr,
    List<UserLeaveRequest>? userLeaveRequests,
    String? leaveType,
  });
}
