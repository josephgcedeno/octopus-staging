import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/expanded_textfield.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/mini_textfield.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/project_list.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_list.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class TaskTextArea extends StatefulWidget {
  const TaskTextArea({Key? key}) : super(key: key);

  @override
  State<TaskTextArea> createState() => _TaskTextAreaState();
}

class _TaskTextAreaState extends State<TaskTextArea> {
  TextEditingController textController = TextEditingController();
  ProjectStatus? projectStatus;
  bool textBoxIsExpanded = false;
  List<ProjectTag> projects = <ProjectTag>[];

  void expandTextBox() => setState(() => textBoxIsExpanded = true);

  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<DSRCubit, DSRState>(
      listenWhen: (DSRState previous, DSRState current) =>
          current is FetchProjectsSuccess,
      listener: (BuildContext context, DSRState state) {
        if (state is FetchProjectsSuccess) {
          setState(() => projects = state.projects);
        }
      },
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: width * 0.9,
                  child: textBoxIsExpanded
                      ? const ExpandedTextField()
                      : MiniTextField(onTap: expandTextBox),
                ),
              ),
              BlocBuilder<DSRCubit, DSRState>(
                buildWhen: (DSRState previous, DSRState current) =>
                    current is ShowProjectPane ||
                    current is ShowStatusPane ||
                    current is HideProjectPane ||
                    current is HideStatusPane,
                builder: (BuildContext context, DSRState state) {
                  if (state is ShowProjectPane) {
                    return ProjectList(projects: projects);
                  } else if (state is ShowStatusPane) {
                    return const StatusList();
                  }
                  return const Positioned(bottom: 0, child: SizedBox.shrink());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
