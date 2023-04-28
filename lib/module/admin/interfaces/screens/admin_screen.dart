import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  static const String routeName = '/admin';

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<IconData> actionIcons = <IconData>[
    Icons.abc,
    Icons.ac_unit,
    Icons.access_alarms_outlined,
    Icons.accessibility_outlined,
    Icons.account_balance_rounded,
  ];

  List<String> actionLabel = <String>[
    'Accomplishments Generator',
    'Leaves',
    'Registration',
    'Historical Data',
    'Employee View'
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

//     Accomplishments Generator
// Steps
// Generate For What Project?
// List all active projects
// Generate for what date?
// Today
// Enter Date
// Fetched from all accomplishments of the day (based on tags attached to tasks)
// Preview All accomplishments of today
// Drop down add items
// Download as PDF or Send via Email
// Leaves
// Set leave amount
// Vacation (7), Sick (unlimited), Emergency Leaves (7)
// See leave requests, approve/decline
// Push notifications
// Registration (controlled by admin only)
// Email textbox
// Position? textbox
// View Historical Data
// Time In / Time Out
// Today
// Enter Date
// Export Data xls
// By individual
// By team
// Leave Requests
// Today
// Enter Date
// DSR
// Today
// Enter Date

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        margin: EdgeInsets.only(bottom: height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Admin Panel',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800, color: Colors.grey),
              ),
            ),
            for (int i = 0; i < 5; i++)
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                right: 8,
                              ),
                              child: Icon(
                                actionIcons[i],
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              actionLabel[i],
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: () {
                          if (i == 4) {
                            Navigator.of(context).popUntil(
                              (Route<dynamic> route) => route.isFirst,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
