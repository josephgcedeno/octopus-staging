import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/dashboard_button.dart';
import 'package:octopus/module/hr_files/interfaces/screens/hr_files_screen.dart';
import 'package:octopus/module/standup_report/interfaces/screens/standup_report_screen.dart';
import 'package:octopus/module/time_record/interfaces/screens/time_record_screen.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({Key? key}) : super(key: key);
  static const String routeName = '/controller';

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.name),
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 500 : width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < 2; i++)
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color(0xFF4BA1FF),
                        Color(0xFF017BFF),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Today is a special holiday.',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: Text(
                  'Tools',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DashboardButton(
                          icon: Icons.timer_outlined,
                          label: 'Daily Time Record',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<dynamic>(
                                builder: (_) => const TimeRecordScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: width * 0.03),
                        DashboardButton(
                          icon: Icons.collections_bookmark_outlined,
                          label: 'Daily Stand-Up Report',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<dynamic>(
                                builder: (_) => const StandupReportScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DashboardButton(
                        icon: Icons.calendar_today_outlined,
                        label: 'Leaves',
                        onTap: () {},
                      ),
                      SizedBox(width: width * 0.03),
                      DashboardButton(
                        icon: Icons.collections_bookmark_outlined,
                        label: 'HR Files',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<dynamic>(
                              builder: (_) => const HRFiles(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
