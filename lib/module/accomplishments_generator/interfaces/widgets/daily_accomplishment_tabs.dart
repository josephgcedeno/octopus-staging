import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class DailyAccomplishmentTabs extends StatefulWidget {
  const DailyAccomplishmentTabs({Key? key}) : super(key: key);

  @override
  State<DailyAccomplishmentTabs> createState() =>
      _DailyAccomplishmentTabsState();
}

class _DailyAccomplishmentTabsState extends State<DailyAccomplishmentTabs>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = <Widget>[
    const Text('Done', textAlign: TextAlign.left),
    const Text('Doing', textAlign: TextAlign.left),
    const Text('Blockers', textAlign: TextAlign.left)
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
              controller: _tabController,
              indicatorColor: theme.primaryColor,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                ),
              ),
              tabs: _tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                Center(child: Text('Done')),
                Center(child: Text('Doing')),
                Center(child: Text('Blocked')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
