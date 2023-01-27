import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.label, Key? key}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: label.isEmpty ? Colors.transparent : Colors.black12,
        ),
        borderRadius: BorderRadius.circular(7),
        color: label.isEmpty ? Colors.black12 : Colors.white,
      ),
      width: width * 0.8,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: theme.textTheme.bodyText2),
    );
  }
}
