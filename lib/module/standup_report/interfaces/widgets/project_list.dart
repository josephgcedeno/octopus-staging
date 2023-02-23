import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/item_list.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({required this.projects, Key? key}) : super(key: key);
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return ItemList(
      itemList: <Widget>[
        for (int i = 0; i < projects.length; i++)
          GestureDetector(
            onTap: () {
              context.read<DSRCubit>().setProject(projects[i]);
            },
            child: Text(projects[i].projectName),
          ),
      ],
    );
  }
}
