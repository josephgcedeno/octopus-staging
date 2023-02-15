import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void expandTextBox() => setState(() => textBoxIsExpanded = true);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Align(
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
                  return const ProjectList();
                } else if (state is ShowStatusPane) {
                  return const StatusList();
                }
                return const Positioned(bottom: 0, child: SizedBox.shrink());
              },
            )
          ],
        ),
      ),
    );
  }
}
