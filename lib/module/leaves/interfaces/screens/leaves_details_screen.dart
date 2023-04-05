import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_details.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_status.dart';

class LeavesDetailsScreen extends StatelessWidget {
  const LeavesDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const GlobalAppBar(
        leading: LeadingButton.back,
      ),
      body: Container(
        height: height * 0.87,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
                  child: Center(
                    child: Text(
                      'Request Leave Details',
                      style: kIsWeb
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                ),
                const Center(
                  child: LeaveStatusIndicator(
                    status: LeaveStatus.approved,
                  ),
                ),
                const LeaveDetails()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
