import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/leave_status.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/panel_reminder.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/tool_available.dart';

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
      appBar: const GlobalAppBar(leading: LeadingButton.name),
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 500 : width * 0.9,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PanelReminder(),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: Text(
                        'Tools',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const ToolsAvailable(),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: PanelLeavesStatus(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
