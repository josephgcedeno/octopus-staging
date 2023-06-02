import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/module/historical_data/interfaces/screens/report_screen_generator.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_screen_template.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

class DailyTimeRecordScreen extends StatelessWidget {
  const DailyTimeRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HistoricalScreenTemplate(
      generateBtnText: 'Generate Daily Time Record',
      title: 'Daily Time Record',
      callback: (CallbackReturnData callbackReturnData) {
        context.read<HistoricalCubit>().fetchAllUserAttendancesReport(
              users: callbackReturnData.users,
              today: callbackReturnData.today,
              to: callbackReturnData.to,
              from: callbackReturnData.from,
            );

        Navigator.of(context).push(
          PageRouteBuilder<dynamic>(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) =>
                SidebarScreen(
              child: ReportScreenGenerator(
                reportDate: startDateToEndDateLabel(
                  to: callbackReturnData.to,
                  from: callbackReturnData.from,
                  today: callbackReturnData.today,
                ),
                reportType: ReportType.attendance,
              ),
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
    );
  }
}
