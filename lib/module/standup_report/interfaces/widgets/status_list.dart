import 'package:flutter/material.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';

class StatusList extends StatelessWidget {
  const StatusList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> status = <String>[
      'Done',
      'Doing',
      'Blocked',
    ];

    return ItemList(items: status);
  }
}
