import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/expanded_textfield.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/mini_textfield.dart';

class StandupReportScreen extends StatefulWidget {
  const StandupReportScreen({Key? key}) : super(key: key);

  static const String routeName = '/dsr';

  @override
  State<StandupReportScreen> createState() => _StandupReportScreenState();
}

class _StandupReportScreenState extends State<StandupReportScreen> {
  TextEditingController textController = TextEditingController();
  bool textBoxIsExpanded = false;
  bool projectsAreShowing = false;
  bool statusIsShowing = false;

  void expandTextBox() {
    setState(() => textBoxIsExpanded = true);
  }

  void toggleProjectsList() {
    setState(() {
      statusIsShowing = false;
      projectsAreShowing = !projectsAreShowing;
    });
  }

  void toggleStatusList() {
    setState(() {
      projectsAreShowing = false;
      statusIsShowing = !statusIsShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.menu),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Text(
            'Daily Stand-Up Report',
            style:
                kIsWeb ? theme.textTheme.headline6 : theme.textTheme.subtitle1,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: height * 0.15),
          //   child: SvgPicture.asset('assets/human_board_graphic.svg'),
          // ),
          // Expanded(
          //   child: Container(
          //     width: width,
          //     color: Colors.red,
          //     child: Text('haha'),
          //   ),
          // ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: width * 0.9,
                        child: textBoxIsExpanded
                            ? ExpandedTextField(
                                onTapProject: toggleProjectsList,
                                onTapStatus: toggleStatusList,
                              )
                            : MiniTextField(onTap: expandTextBox),
                      ),
                    ),
                    if (projectsAreShowing || statusIsShowing)
                      ItemList(isShowProject: projectsAreShowing)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
