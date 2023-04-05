import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NumberOfLeaves extends StatelessWidget {
  const NumberOfLeaves({
    required this.count,
    required this.type,
    Key? key,
  }) : super(key: key);
  final int count;
  final String type;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: theme.primaryColor.withAlpha(30),
                blurRadius: 30,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              type,
              style: kIsWeb
                  ? theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    )
                  : theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        )
      ],
    );
  }
}
