import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Hi there!',
            style:
                theme.textTheme.displayLarge?.copyWith(fontSize: height * 0.05),
          ),
          TextSpan(
            text: "\nLet's get you ",
            style:
                theme.textTheme.displayLarge?.copyWith(fontSize: height * 0.05),
          ),
          TextSpan(
            text: 'prepared',
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.primaryColor,
              fontSize: height * 0.05,
            ),
          ),
          TextSpan(
            text: '.',
            style:
                theme.textTheme.displayLarge?.copyWith(fontSize: height * 0.05),
          ),
        ],
      ),
    );
  }
}
