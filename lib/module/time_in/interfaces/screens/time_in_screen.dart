import 'package:flutter/material.dart';

class TimeInScreen extends StatefulWidget {
  const TimeInScreen({Key? key}) : super(key: key);

  static const String routeName = '/time_in';

  @override
  State<TimeInScreen> createState() => _TimeInScreenState();
}

class _TimeInScreenState extends State<TimeInScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    // controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;

    return Column(
      children: const <Widget>[
        Center(child: Text('Time IN/OUT Screen')),
      ],
    );
  }
}
