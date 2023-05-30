import 'package:flutter/material.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/expanded_textfield.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/mini_textfield.dart';

class TaskTextArea extends StatefulWidget {
  const TaskTextArea({Key? key}) : super(key: key);

  @override
  State<TaskTextArea> createState() => _TaskTextAreaState();
}

class _TaskTextAreaState extends State<TaskTextArea> {
  TextEditingController textController = TextEditingController();
  bool textBoxIsExpanded = false;

  void expandTextBox() => setState(() => textBoxIsExpanded = true);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: textBoxIsExpanded
          ? const ExpandedTextField()
          : MiniTextField(onTap: expandTextBox),
    );
  }
}
