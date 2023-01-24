import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/tool_button.dart';
import 'package:octopus/module/time_in/interfaces/screens/time_in_screen.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({Key? key}) : super(key: key);
  static const String routeName = '/controller';

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Good Morning!\n',
                style: theme.textTheme.bodyText2?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: 'Angel', style: theme.textTheme.caption),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: width * 0.025),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.face,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              padding: EdgeInsets.symmetric(vertical: height * 0.015),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color(0xFF4BA1FF),
                    Color(0xFF017BFF),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'Today is a special holiday.',
                  style:
                      theme.textTheme.subtitle1?.copyWith(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Text(
                'Tools',
                style: theme.textTheme.bodyText2
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ToolButton(
                        icon: Icons.timer_outlined,
                        label: 'Daily Time Record',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<dynamic>(
                              builder: (_) => const TimeInScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: width * 0.03),
                      ToolButton(
                        icon: Icons.collections_bookmark_outlined,
                        label: 'Daily Stand-Up Report',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ToolButton(
                      icon: Icons.calendar_today_outlined,
                      label: 'Leaves',
                      onTap: () {},
                    ),
                    SizedBox(width: width * 0.03),
                    ToolButton(
                      icon: Icons.collections_bookmark_outlined,
                      label: 'HR Files',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
