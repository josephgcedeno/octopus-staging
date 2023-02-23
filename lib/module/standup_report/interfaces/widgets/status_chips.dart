import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

enum TaskStatus {
  done,
  doing,
  blockers,
}

class StatusChips extends StatelessWidget {
  const StatusChips({
    required this.status,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  final TaskStatus status;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = theme.primaryColor.withAlpha(40);
    const Color inactiveColor = Color(0xFFf5f7f9);

    return Container(
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(top: 10, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 17),
      child: Text(
        toBeginningOfSentenceCase(status.name) ?? '',
        style: theme.textTheme.caption
            ?.copyWith(color: isActive ? theme.primaryColor : Colors.black),
      ),
    );
  }
}
