import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:octopus/module/historical_data/interfaces/screens/report_screen_generator.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_screen_template.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HistoricalScreenTemplate(
      title: 'Leave Requests',
      generateBtnText: 'Generate Leave Requests',
      dropDownValue: DropDownValue(
        hintText: 'Select type of leave',
        options: <String>[
          leaveTypeSickLeave,
          leaveTypeVacationLeave,
          leaveTypeEmergencyLeave,
        ],
        dropdownType: DropdownType.leave,
      ),
      callback: (CallbackReturnData callbackReturnData) {
        inspect(callbackReturnData);
        Navigator.of(context).push(
          MaterialPageRoute<dynamic>(
            builder: (_) => ReportScreenGenerator(
              reportDate: startDateToEndDateLabel(
                to: callbackReturnData.to,
                from: callbackReturnData.from,
                today: callbackReturnData.today,
              ),
              reportType: ReportType.leaveReques,
              leaveType: callbackReturnData.dropdownValueSelected,
            ),
          ),
        );
      },
    );
  }
}
