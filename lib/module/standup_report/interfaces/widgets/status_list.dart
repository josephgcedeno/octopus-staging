import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class StatusList extends StatelessWidget {
  const StatusList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> status = <String>[
      'Done',
      'Doing',
      'Blocked',
    ];

    ProjectStatus? projectStatus(int i) {
      switch (i) {
        case 0:
          return ProjectStatus.done;
        case 1:
          return ProjectStatus.doing;
        case 2:
          return ProjectStatus.blockers;
        default:
          return null;
      }
    }

    return ItemList(
      itemList: <Widget>[
        for (int i = 0; i < status.length; i++)
          GestureDetector(
            onTap: () {
              context.read<DSRCubit>().projectStatus = projectStatus(i);
            },
            child: Text(status[i]),
          ),
      ],
    );
  }
}
