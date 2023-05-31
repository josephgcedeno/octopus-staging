import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_details.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_status.dart';

class LeavesDetailsScreen extends StatelessWidget {
  const LeavesDetailsScreen({
    required this.leaveRequest,
    Key? key,
  }) : super(key: key);
  final LeaveRequest leaveRequest;

  LeaveStatus getLeaveRequst() {
    switch (leaveRequest.status) {
      case 'APPROVED':
        return LeaveStatus.approved;
      case 'PENDING':
        return LeaveStatus.pending;
      case 'DENIED':
        return LeaveStatus.denied;
      default:
        return LeaveStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(
        leading: LeadingButton.back,
      ),
      body: Container(
        height: height * 0.87,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
              child: Align(
                alignment: kIsWeb && width > smWebMinWidth
                    ? Alignment.centerLeft
                    : Alignment.center,
                child: Text(
                  'Request Leave Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              child: SizedBox(
                width: kIsWeb && width > smWebMinWidth ? width * 0.35 : width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LeaveStatusIndicator(
                          status: getLeaveRequst(),
                        ),
                        LeaveDetails(
                          leaveRequest: leaveRequest,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
