import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_request.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/date_card.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/project_list.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_list.dart';
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
  List<Project> projects = <Project>[];

  double opacityLevel = 1.0;

  Timer interval = Timer(const Duration(seconds: 1), () {});

  void addTasksLocally(
    ProjectStatus status,
    String label,
    String projectId,
  ) {
    switch (status) {
      case ProjectStatus.done:
        setState(() {
          done.add(
            TaskCardDTO(
              taskName: label,
              projectId: projectId,
              status: 0,
            ),
          );
        });
        break;
      case ProjectStatus.doing:
        setState(() {
          doing.add(
            TaskCardDTO(
              taskName: label,
              projectId: projectId,
              status: 1,
            ),
          );
        });
        break;
      case ProjectStatus.blockers:
        setState(() {
          blockers.add(
            TaskCardDTO(
              taskName: label,
              projectId: projectId,
              status: 2,
            ),
          );
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().fetchCurrentDate();
    context.read<DSRCubit>().initializeDSR();
    context.read<DSRCubit>().getAllProjects();

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
    final List<Widget> statusWidgets = <Widget>[
      StatusColumn(
        data: done,
        status: ProjectStatus.done,
        projects: projects,
      ),
      StatusColumn(
        data: doing,
        status: ProjectStatus.doing,
        projects: projects,
      ),
      StatusColumn(
        data: blockers,
        status: ProjectStatus.blockers,
        projects: projects,
      ),
    ];

    final List<Widget> noCardsImage = <Widget>[
      Padding(
        padding: EdgeInsets.only(top: height * 0.1),
        child: SvgPicture.asset('assets/images/tasks.svg'),
      )
    ];

    void errorSnackbar(String message) => showSnackBar(
          message: message,
          snackBartState: SnackBartState.error,
        );

    return BlocListener<DSRCubit, DSRState>(
      listenWhen: (DSRState previous, DSRState current) =>
          current is InitializeDSRLoading ||
          current is InitializeDSRFailed ||
          current is InitializeDSRSuccess ||
          current is UpdateTaskLoading ||
          current is FetchProjectsSuccess ||
          current is FetchProjectsFailed,
      listener: (BuildContext context, DSRState state) {
        interval.cancel();
        if (state is UpdateTaskLoading) {
          addTasksLocally(state.status, state.taskLabel, state.projectTagId);
          if (noCardsYet) {
            setState(() => noCardsYet = false);
          }
        } else if (state is FetchProjectsSuccess) {
          projects = state.projects;
        } else if (state is InitializeDSRSuccess) {
          final List<List<TaskCardDTO>> localProjectLists = <List<TaskCardDTO>>[
            done,
            doing,
            blockers
          ];

          final List<List<Task>> updatedProjectList = <List<Task>>[
            state.done,
            state.doing,
            state.blockers,
          ];

          for (int i = 0; i < localProjectLists.length; i++) {
            localProjectLists[i].clear();
            for (int j = 0; j < updatedProjectList[i].length; j++) {
              localProjectLists[i].add(
                TaskCardDTO(
                  taskName: updatedProjectList[i][j].text,
                  projectId: updatedProjectList[i][j].projectTagId,
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
        } else if (state is UpdateTaskFailed) {
          errorSnackbar(state.message);
          context.read<DSRCubit>().initializeDSR();
        } else if (state is FetchProjectsFailed) {
          errorSnackbar(state.message);
        } else if (state is InitializeDSRFailed) {
          errorSnackbar(state.message);
        } else if (state is InitializeDSRLoading) {
          setState(() => isLoading = true);
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.menu),
        backgroundColor: Colors.white,
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Daily Stand-Up Report',
                    style: kIsWeb
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium,
                  ),
                  const DateCard(),
                ],
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: isLoading
                          ? ListView(
                              padding: EdgeInsets.only(
                                bottom: height * 0.2,
                                top: 20,
                                left: 5,
                              ),
                              children: itemLoader(
                                innerItem: 2,
                                outerItem: 3,
                              ),
                            )
                          : kIsWeb && width > smWebMinWidth
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      noCardsYet ? noCardsImage : statusWidgets,
                                )
                              : FadeIn(
                                  duration: fadeInDuration,
                                  child: ListView(
                                    children: noCardsYet
                                        ? noCardsImage
                                        : statusWidgets,
                                  ),
                                ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BlocBuilder<DSRCubit, DSRState>(
                        buildWhen: (DSRState previous, DSRState current) =>
                            current is ShowProjectPane ||
                            current is ShowStatusPane ||
                            current is HideProjectPane ||
                            current is HideStatusPane,
                        builder: (BuildContext context, DSRState state) {
                          if (state is ShowProjectPane) {
                            return ProjectList(
                              projects: projects,
                            );
                          } else if (state is ShowStatusPane) {
                            return const StatusList();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const TaskTextArea()
            ],
          ),
        ),
      ),
    );
  }
}
