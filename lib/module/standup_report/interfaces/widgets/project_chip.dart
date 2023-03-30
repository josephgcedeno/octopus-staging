import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ProjectChip extends StatelessWidget {
  const ProjectChip({
    required this.id,
    required this.name,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String id;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(60),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        toBeginningOfSentenceCase(name) ?? '',
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
