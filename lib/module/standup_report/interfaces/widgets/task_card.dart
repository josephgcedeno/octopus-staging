import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/module/standup_report/interfaces/screens/edit_task_screen.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.label, Key? key}) : super(key: key);

  final String label;

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
            color: label.isEmpty ? Colors.transparent : Colors.black12,
          ),
          borderRadius: BorderRadius.circular(7),
          color: label.isEmpty ? Colors.black12 : Colors.white,
        ),
        width: kIsWeb ? width * 0.3 : width * 0.8,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(label, style: theme.textTheme.bodyText2),
      ),
    );
  }
}
