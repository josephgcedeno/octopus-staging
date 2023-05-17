import 'package:flutter/material.dart';
import 'package:octopus/internal/string_status.dart';
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
      callback: (CallbackReturnData callbackReturnData) {},
    );
  }
}
