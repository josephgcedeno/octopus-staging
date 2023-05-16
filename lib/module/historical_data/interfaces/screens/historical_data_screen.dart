import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/historical_data/interfaces/screens/daily_time_record_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/dsr_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/leave_request_screen.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_menu_button.dart';

class HistoricalDataScreen extends StatelessWidget {
  const HistoricalDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
                child: Center(
                  child: Text(
                    'Historical Data',
                    style: kIsWeb
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HistoricalMenuButton(
                      icon: Icons.punch_clock_outlined,
                      title: 'Daily Time Record',
                      functionCall: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const DailyTimeRecordScreen(),
                          ),
                        );
                      },
                    ),
                    HistoricalMenuButton(
                      icon: Icons.folder_outlined,
                      title: 'Daily Standup Report',
                      functionCall: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const DailyStandUpReportScreen(),
                          ),
                        );
                      },
                    ),
                    HistoricalMenuButton(
                      icon: Icons.calendar_today_outlined,
                      title: 'Leave Requests',
                      functionCall: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const LeaveRequestScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
