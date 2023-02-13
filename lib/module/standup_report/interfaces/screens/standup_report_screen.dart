import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/task_textarea.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';
import 'package:octopus/module/standup_report/service/cubit/task_card_dto.dart';

class StandupReportScreen extends StatefulWidget {
  const StandupReportScreen({Key? key}) : super(key: key);

  static const String routeName = '/dsr';

  @override
  State<StandupReportScreen> createState() => _StandupReportScreenState();
}

class _StandupReportScreenState extends State<StandupReportScreen> {
  List<TaskCardDTO> doing = <TaskCardDTO>[
    TaskCardDTO(taskName: 'Sample Task 1', taskID: '0', status: 0),
    TaskCardDTO(taskName: 'Sample Task 2', taskID: '1', status: 0),
    TaskCardDTO(taskName: 'Sample Task 3', taskID: '2', status: 0),
    TaskCardDTO(taskName: 'Sample Task 4', taskID: '3', status: 0),
  ];

  List<TaskCardDTO> done = <TaskCardDTO>[
    TaskCardDTO(taskName: 'Sample Task 5', taskID: '4', status: 1),
  ];

  List<TaskCardDTO> blockers = <TaskCardDTO>[
    TaskCardDTO(taskName: 'Sample Task 6', taskID: '5', status: 2),
  ];

  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().fetchCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final List<Widget> statusWidgets = <Widget>[
      StatusColumn(data: doing, status: ProjectStatus.doing),
      StatusColumn(data: done, status: ProjectStatus.done),
      StatusColumn(
        data: blockers,
        status: ProjectStatus.blockers,
      ),
    ];

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.menu),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Column(
              children: <Widget>[
                Text(
                  'Daily Stand-Up Report',
                  style: kIsWeb
                      ? theme.textTheme.headline6
                      : theme.textTheme.subtitle1,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: theme.primaryColor.withOpacity(0.1),
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: BlocBuilder<DSRCubit, DSRState>(
                    buildWhen: (DSRState previous, DSRState current) =>
                        current is FetchDatesSuccess ||
                        current is FetchDatesLoading,
                    builder: (BuildContext context, DSRState state) {
                      if (state is FetchDatesSuccess) {
                        return Text(
                          state.dateString,
                          style: theme.textTheme.overline?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.5,
                        child: const LinearProgressIndicator(),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.02),
                  height: height,
                  width: width,
                  child: kIsWeb
                      ? Row(children: statusWidgets)
                      : ListView(children: statusWidgets),
                ),
              ],
            ),
          ),
          const TaskTextArea()
        ],
      ),
    );
  }
}
