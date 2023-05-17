import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/report_dsr_page.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/report_dtr_page.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/report_leave_page.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

class ReportScreenPageGenerator extends StatefulWidget {
  const ReportScreenPageGenerator({Key? key}) : super(key: key);

  @override
  State<ReportScreenPageGenerator> createState() =>
      _ReportScreenPageGeneratorState();
}

class _ReportScreenPageGeneratorState extends State<ReportScreenPageGenerator> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocConsumer<HistoricalCubit, HistoricalState>(
      listenWhen: (HistoricalState previous, HistoricalState current) =>
          current is FetchLeaveReportFailed ||
          current is FetchAttendancesReportFailed ||
          current is FetchDSRReportFailed,
      listener: (BuildContext context, HistoricalState state) {
        if (state is FetchLeaveReportFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
        if (state is FetchAttendancesReportFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
        if (state is FetchDSRReportFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      buildWhen: (HistoricalState previous, HistoricalState current) =>
          current is FetchLeaveReportLoading ||
          current is FetchLeaveReportSuccess ||
          current is FetchAttendancesReportLoading ||
          current is FetchAttendancesReportSucces ||
          current is FetchDSRReportLoading ||
          current is FetchDSRReportSuccess,
      builder: (BuildContext context, HistoricalState state) {
        if (state is FetchAttendancesReportSucces) {
          return ReportDTRPage(
            employeeAttendances: state.employeeAttendances,
          );
        } else if (state is FetchDSRReportSuccess) {
          return ReportDSRPage(userDsr: state.userDsr);
        } else if (state is FetchLeaveReportSuccess) {
          return ReportLeavePage(
            userLeaveRequests: state.userLeaveRequests,
            leaveType: state.leaveType,
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Container(
              child: lineLoader(height: height * 0.60, width: width),
            ),
          ),
        );
      },
    );
  }
}
