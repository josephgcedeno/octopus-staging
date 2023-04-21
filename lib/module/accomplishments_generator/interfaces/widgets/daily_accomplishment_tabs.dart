import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/accomplishments_generator_screen.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';

class DailyAccomplishmentTabs extends StatefulWidget {
  const DailyAccomplishmentTabs({required this.reportTasks, Key? key})
      : super(key: key);

  final Map<String, List<Map<String, String>>> reportTasks;

  @override
  State<DailyAccomplishmentTabs> createState() =>
      _DailyAccomplishmentTabsState();
}

class _DailyAccomplishmentTabsState extends State<DailyAccomplishmentTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: reportTasks.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: height * 0.44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: width,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: kDarkGrey),
              ),
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelStyle: theme.textTheme.bodySmall,
              labelColor: theme.primaryColor,
              unselectedLabelColor: kBlack,
              tabs: reportTasks.keys
                  .map(
                    (String key) => Visibility(
                        visible: reportTasks[key]!.isNotEmpty,
                        child: Text(key.toUpperCase())),
                  )
                  .toList(),
              controller: _tabController,
              indicatorColor: theme.primaryColor,
              labelPadding: EdgeInsets.symmetric(horizontal: width * 0.02),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return ktransparent;
                  } else {
                    return null;
                  }
                },
              ),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: reportTasks.keys
                  .map(
                    (String key) => Column(
                      children: reportTasks[key]!
                          .map(
                            (Map<String, String> task) =>
                                AccomplishmentsTaskChecker(
                              title: task['text']!,
                              type: CheckerType.selected,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
