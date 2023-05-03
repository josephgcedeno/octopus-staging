import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';

class DailyAccomplishmentTabs extends StatefulWidget {
  const DailyAccomplishmentTabs({Key? key}) : super(key: key);

  @override
  State<DailyAccomplishmentTabs> createState() =>
      _DailyAccomplishmentTabsState();
}

class _DailyAccomplishmentTabsState extends State<DailyAccomplishmentTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<DSRWorks>>? selectedTasks =
      context.read<AccomplishmentsCubit>().state.selectedTasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: selectedTasks!.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String changeTabLabel(String tabName) {
    if (tabName == 'work_in_progress') {
      return 'DOING';
    } else if (tabName == 'blockers') {
      return 'BLOCKED';
    }
    return tabName.toUpperCase();
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
          if (selectedTasks != null)
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
                tabs: selectedTasks!.keys
                    .map(
                      (String key) => Visibility(
                        visible: selectedTasks![key]!.isNotEmpty,
                        child: Text(
                          changeTabLabel(key),
                        ),
                      ),
                    )
                    .toList(),
                controller: _tabController,
                indicatorColor: theme.primaryColor,
                labelPadding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.008),
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
              children: selectedTasks!.keys
                  .map(
                    (String key) => Column(
                      children: <Widget>[
                        for (DSRWorks task in selectedTasks![key]!)
                          AccomplishmentsTaskChecker(
                            title: task.text,
                            type: CheckerType.selected,
                            hasProfile: false,
                          )
                      ],
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
