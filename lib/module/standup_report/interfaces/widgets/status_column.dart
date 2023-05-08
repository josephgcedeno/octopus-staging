import 'package:flutter/material.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/task_card.dart';
import 'package:octopus/module/standup_report/service/cubit/task_card_dto.dart';

enum ProjectStatus {
  done,
  doing,
  blockers,
}

class StatusColumn extends StatefulWidget {
  const StatusColumn({
    required this.data,
    required this.status,
    required this.projects,
    Key? key,
  }) : super(key: key);

  final List<TaskCardDTO> data;
  final ProjectStatus status;
  final List<Project> projects;
  // final void Function() onDragEnd;

  @override
  State<StatusColumn> createState() => _StatusColumnState();
}

class _StatusColumnState extends State<StatusColumn> {
  Project emptyProject = Project(
    id: '-1',
    projectName: 'Unknown',
    dateEpoch: 0,
    status: 'DONE',
    color: '0x000000',
    logoImage: '',
  );

  Project? getTaskProject(String id) {
    for (int i = 0; i < widget.projects.length; i++) {
      if (id == widget.projects[i].id) {
        return widget.projects[i];
      }
    }
    return null;
  }

  int statusCodeToInt() {
    switch (widget.status) {
      case ProjectStatus.done:
        return 0;
      case ProjectStatus.doing:
        return 1;
      case ProjectStatus.blockers:
        return 2;
    }
  }

  String intToStatusCode() {
    switch (widget.status) {
      case ProjectStatus.done:
        return 'Done';
      case ProjectStatus.doing:
        return 'Doing';
      case ProjectStatus.blockers:
        return 'Blockers';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.3,
      padding: widget.status == ProjectStatus.blockers
          ? EdgeInsets.only(bottom: height * 0.2, left: 8, right: 8, top: 8)
          : const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            padding: EdgeInsets.only(
              left: width * 0.1,
              bottom: widget.data.isEmpty ? height * 0.1 : 8,
            ),
            child: Text(intToStatusCode()),
          ),
          for (int i = 0; i < widget.data.length; i++)
            TaskCard(
              task: widget.data[i],
              projectTag:
                  getTaskProject(widget.data[i].projectId) ?? emptyProject,
            )
        ],
      ),
    );
  }
}
