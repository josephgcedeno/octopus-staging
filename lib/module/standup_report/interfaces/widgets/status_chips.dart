import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

enum TaskStatus {
  done,
  doing,
  blockers,
}

class StatusChips extends StatelessWidget {
  const StatusChips({required this.status, Key? key}) : super(key: key);

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color backgroundColor() {
      switch (status) {
        case TaskStatus.doing:
          return theme.primaryColor.withAlpha(40);
        case TaskStatus.done:
          return const Color(0xFF5CD39A).withAlpha(30);
        case TaskStatus.blockers:
          return Colors.black12;
      }
    }

    Color fontColor() {
      switch (status) {
        case TaskStatus.doing:
          return theme.primaryColor;
        case TaskStatus.done:
          return Colors.green;
        case TaskStatus.blockers:
          return Colors.black;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor(),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(top: 10, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
      child: Text(
        toBeginningOfSentenceCase(status.name) ?? '',
        style: theme.textTheme.caption?.copyWith(color: fontColor()),
      ),
    );
  }
}
