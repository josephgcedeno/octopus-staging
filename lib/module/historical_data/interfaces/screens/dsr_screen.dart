import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/module/historical_data/interfaces/screens/report_screen_generator.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_screen_template.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class DailyStandUpReportScreen extends StatefulWidget {
  const DailyStandUpReportScreen({Key? key}) : super(key: key);

  @override
  State<DailyStandUpReportScreen> createState() =>
      _DailyStandUpReportScreenState();
}

class _DailyStandUpReportScreenState extends State<DailyStandUpReportScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DSRCubit, DSRState>(
      buildWhen: (DSRState previous, DSRState current) =>
          current is FetchProjectsSuccess,
      builder: (BuildContext context, DSRState state) {
        if (state is FetchProjectsSuccess) {
          final List<String> projects =
              state.projects.map((Project obj) => obj.projectName).toList();
          return HistoricalScreenTemplate(
            title: 'Daily Standup Report',
            generateBtnText: 'Generate Daily Standup Report',
            dropDownValue: DropDownValue(
              hintText: 'All Projects',
              options: <String>['All Projects', ...projects],
              dropdownType: DropdownType.dsr,
            ),
            callback: (CallbackReturnData callbackReturnData) {
              final String projectId = state.projects
                  .firstWhere(
                    (Project element) =>
                        element.projectName ==
                        callbackReturnData.dropdownValueSelected,
                    orElse: () => Project(
                      color: '',
                      dateEpoch: 1,
                      id: '-1',
                      logoImage: '',
                      projectName: '',
                      status: '',
                    ),
                  )
                  .id;

              context.read<HistoricalCubit>().fetchDSRReport(
                    users: callbackReturnData.users,
                    today: callbackReturnData.today,
                    to: callbackReturnData.to,
                    from: callbackReturnData.from,
                    projectsId: projectId == '-1' ? null : projectId,
                  );

              Navigator.of(context).push(
                MaterialPageRoute<dynamic>(
                  builder: (_) => ReportScreenGenerator(
                    reportDate: startDateToEndDateLabel(
                      to: callbackReturnData.to,
                      from: callbackReturnData.from,
                      today: callbackReturnData.today,
                    ),
                    reportType: ReportType.dsr,
                  ),
                ),
              );
            },
          );
        }

        return HistoricalScreenTemplate(
          title: 'Daily Standup Report',
          generateBtnText: 'Generate Daily Standup Report',
          isDropdownLoading: true,
          callback: (CallbackReturnData callbackReturnData) {},
        );
      },
    );
  }
}
