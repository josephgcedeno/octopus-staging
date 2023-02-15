import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
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
  bool isLoading = true;
  bool noCardsYet = false;

  List<TaskCardDTO> doing = <TaskCardDTO>[];
  List<TaskCardDTO> done = <TaskCardDTO>[];
  List<TaskCardDTO> blockers = <TaskCardDTO>[];

  double opacityLevel = 1.0;

  Timer interval = Timer(const Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().fetchCurrentDate();
    context.read<DSRCubit>().initializeDSR();
    interval = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    interval.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final List<Widget> noCardsImage = <Widget>[
      Padding(
        padding: EdgeInsets.only(top: height * 0.1),
        child: SvgPicture.asset('assets/images/tasks.svg'),
      )
    ];

    final List<Widget> statusWidgets = <Widget>[
      StatusColumn(data: doing, status: ProjectStatus.doing),
      StatusColumn(data: done, status: ProjectStatus.done),
      StatusColumn(
        data: blockers,
        status: ProjectStatus.blockers,
      ),
    ];

    return BlocListener<DSRCubit, DSRState>(
      listenWhen: (DSRState previous, DSRState current) =>
          current is InitializeDSRLoading ||
          current is InitializeDSRFailed ||
          current is InitializeDSRSuccess,
      listener: (BuildContext context, DSRState state) {
        if (state is InitializeDSRSuccess) {
          final List<List<TaskCardDTO>> localProjectLists = <List<TaskCardDTO>>[
            doing,
            done,
            blockers
          ];

          final List<List<DSRWorkTrack>> updatedProjectList =
              <List<DSRWorkTrack>>[
            state.doing,
            state.done,
            state.blockers,
          ];

          for (int i = 0; i < localProjectLists.length; i++) {
            localProjectLists[i].clear();
            for (int j = 0; j < updatedProjectList[i].length; j++) {
              localProjectLists[i].add(
                TaskCardDTO(
                  taskName: updatedProjectList[i][j].text,
                  taskID: updatedProjectList[i][j].projectTagId,
                  status: i,
                ),
              );
            }
          }

          if (doing.isEmpty && done.isEmpty && blockers.isEmpty) {
            setState(() => noCardsYet = true);
          }

          /// We run the setState outside the loop to save on resources
          setState(() {
            isLoading = false;
            doing = doing;
          });
        } else if (state is InitializeDSRLoading) {
          setState(() => isLoading = true);
        }
      },
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
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
                          child: const LinearProgressIndicator(
                            minHeight: 2,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: height * 0.02),
                    height: isLoading ? height * 0.6 : height,
                    width: width,
                    child: isLoading
                        ? Align(
                            child: AnimatedOpacity(
                              opacity: opacityLevel,
                              duration: const Duration(milliseconds: 500),
                              child: const Icon(
                                Icons.blur_on_outlined,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : kIsWeb
                            ? Row(
                                children:
                                    noCardsYet ? noCardsImage : statusWidgets,
                              )
                            : ListView(
                                children:
                                    noCardsYet ? noCardsImage : statusWidgets,
                              ),
                  )
                ],
              ),
            ),
            const TaskTextArea()
          ],
        ),
      ),
    );
  }
}
