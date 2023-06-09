import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/historical_data/interfaces/screens/daily_time_record_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/dsr_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/leave_request_screen.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_menu_button.dart';

class HistoricalDataScreen extends StatelessWidget {
  const HistoricalDataScreen({Key? key}) : super(key: key);

  List<HistoricalMenuButton> historicalMenuButtons(BuildContext context) =>
      <HistoricalMenuButton>[
        HistoricalMenuButton(
          icon: Icons.punch_clock_outlined,
          title: 'Daily Time Record',
          functionCall: () {
            Navigator.of(context).push(
              PageRouteBuilder<dynamic>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation1,
                  Animation<double> animation2,
                ) =>
                    const SidebarScreen(
                  child: DailyTimeRecordScreen(),
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
        HistoricalMenuButton(
          icon: Icons.folder_outlined,
          title: 'Daily Standup Report',
          functionCall: () {
            Navigator.of(context).push(
              PageRouteBuilder<dynamic>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation1,
                  Animation<double> animation2,
                ) =>
                    const SidebarScreen(
                  child: DailyStandUpReportScreen(),
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
        HistoricalMenuButton(
          icon: Icons.calendar_today_outlined,
          title: 'Leave Requests',
          functionCall: () {
            Navigator.of(context).push(
              PageRouteBuilder<dynamic>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation1,
                  Animation<double> animation2,
                ) =>
                    const SidebarScreen(
                  child: LeaveRequestScreen(),
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
      ];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.03,
                  top: 20,
                  left: 25.0,
                  right: 25.0,
                ),
                child: Align(
                  alignment: kIsWeb && width > smWebMinWidth
                      ? Alignment.centerLeft
                      : Alignment.center,
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
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: historicalMenuButtons(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
