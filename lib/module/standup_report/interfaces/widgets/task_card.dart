import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/module/standup_report/interfaces/screens/edit_task_screen.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/project_chip.dart';
import 'package:octopus/module/standup_report/service/cubit/task_card_dto.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.projectTag,
    Key? key,
  }) : super(key: key);

  final TaskCardDTO task;
  final ProjectTag projectTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<dynamic>(
            builder: (_) => const EditTaskScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: task.taskName.isEmpty ? Colors.transparent : Colors.black12,
          ),
          borderRadius: BorderRadius.circular(7),
          color: task.taskName.isEmpty ? Colors.black12 : Colors.white,
        ),
        width: kIsWeb ? width * 0.3 : width * 0.8,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(task.taskName, style: theme.textTheme.bodyText2),
            ProjectChip(
              id: projectTag.id,
              name: projectTag.projectName,
              color: Color(int.parse(projectTag.color)),
            ),
          ],
        ),
      ),
    );
  }
}
