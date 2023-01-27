import 'package:flutter/material.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/expanded_textfield.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/mini_textfield.dart';

class TaskTextArea extends StatefulWidget {
  const TaskTextArea({Key? key}) : super(key: key);

  @override
  State<TaskTextArea> createState() => _TaskTextAreaState();
}

class _TaskTextAreaState extends State<TaskTextArea> {
  TextEditingController textController = TextEditingController();
  bool textBoxIsExpanded = false;
  bool projectsAreShowing = false;
  bool statusIsShowing = false;

  void expandTextBox() {
    setState(() => textBoxIsExpanded = true);
  }

  void toggleProjectsList() {
    setState(() {
      statusIsShowing = false;
      projectsAreShowing = !projectsAreShowing;
    });
  }

  void toggleStatusList() {
    setState(() {
      projectsAreShowing = false;
      statusIsShowing = !statusIsShowing;
    });
  }

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
                    ? ExpandedTextField(
                        onTapProject: toggleProjectsList,
                        onTapStatus: toggleStatusList,
                      )
                    : MiniTextField(onTap: expandTextBox),
              ),
            ),
            if (projectsAreShowing || statusIsShowing)
              ItemList(isShowProject: projectsAreShowing)
          ],
        ),
      ),
    );
  }
}
