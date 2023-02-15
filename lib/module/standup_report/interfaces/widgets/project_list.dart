import 'package:flutter/material.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> projects = <String>[
      'Project Octopus',
      'NFTDeals-blocsport1',
      'FrontRx',
      'Metapad',
      'CoinMode'
    ];

    return ItemList(items: projects);
  }
}
