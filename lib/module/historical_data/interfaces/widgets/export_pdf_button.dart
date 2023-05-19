import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

class ExportPDFButton extends StatelessWidget {
  const ExportPDFButton({
    required this.dateReport,
    required this.title,
    Key? key,
  }) : super(key: key);
  final String dateReport;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<HistoricalCubit, HistoricalState>(
      buildWhen: (HistoricalState previous, HistoricalState current) =>
          current is ExportPDFLoading ||
          current is FetchLeaveReportLoading ||
          current is FetchLeaveReportSuccess ||
          current is FetchAttendancesReportLoading ||
          current is FetchAttendancesReportSucces ||
          current is FetchDSRReportLoading ||
          current is FetchDSRReportSuccess,
      builder: (BuildContext context, HistoricalState state) {
        if (state is FetchLeaveReportSuccess ||
            state is FetchAttendancesReportSucces ||
            state is FetchDSRReportSuccess ||
            state is ExportPDFSucess) {
          return ElevatedButton(
            onPressed: () => context.read<HistoricalCubit>().exportPDFReport(
                  dateReport: dateReport,
                  title: title,
                ),
            style: ElevatedButton.styleFrom(
              elevation: 0, // Adjust the elevation as needed
              backgroundColor: kBlue.withOpacity(0.10),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.02,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Export ${title.toTitleCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.primaryColor,
                ),
              ],
            ),
          );
        }

        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            elevation: 0, // Adjust the elevation as needed
            backgroundColor: kBlue.withOpacity(0.10),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Export ${title.toTitleCase()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}
