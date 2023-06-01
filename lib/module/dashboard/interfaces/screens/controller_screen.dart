import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/greetings_status.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/leave_status.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/panel_reminder.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/tool_available.dart';

class ControllerScreen extends StatelessWidget {
  const ControllerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: GlobalAppBar(
          leading: kIsWeb && width > smWebMinWidth
              ? LeadingButton.dashboard
              : LeadingButton.name,
        ),
        body: Center(
          child: SizedBox(
            width: kIsWeb && width > smWebMinWidth ? width * 0.63 : width * 0.9,
            height: height,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const PanelLeavesStatus panelLeavesStatus = PanelLeavesStatus();
                const ToolsAvailable toolsAvailable = ToolsAvailable();
                const PanelReminder panelReminder = PanelReminder();

                return kIsWeb && width > smWebMinWidth
                    ? Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: constraints.maxWidth * 0.40,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: GreetingsStatus(),
                                    ),
                                    panelReminder,
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: panelLeavesStatus,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    child: Text(
                                      'Tools',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  toolsAvailable,
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: panelReminder,
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: height * 0.02,
                                  ),
                                  child: Text(
                                    'Tools',
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                toolsAvailable,
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: panelLeavesStatus,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
