import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_chips.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_column.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';
import 'package:octopus/module/standup_report/service/cubit/task_card_dto.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({required this.task, Key? key}) : super(key: key);
  static const String routeName = '/edit_task';

  final TaskCardDTO task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final OutlineInputBorder descriptionBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10),
  );

  TextEditingController textController = TextEditingController();
  Color formBackgroundColor = const Color(0xFFf5f7f9);
  List<Project> projectList = <Project>[];
  Project? projectTag;

  bool doingIsActive = false;
  bool doneIsActive = false;
  bool blockersIsActive = false;
  int statusInt = -1;

  void setStatusesToFalse() {
    doingIsActive = false;
    doneIsActive = false;
    blockersIsActive = false;
  }

  void updateStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.done:
        setStatusesToFalse();
        context.read<DSRCubit>().projectStatus = ProjectStatus.done;
        statusInt = 0;
        setState(() => doneIsActive = true);
        break;
      case ProjectStatus.doing:
        setStatusesToFalse();
        context.read<DSRCubit>().projectStatus = ProjectStatus.doing;
        statusInt = 1;
        setState(() => doingIsActive = true);
        break;
      case ProjectStatus.blockers:
        setStatusesToFalse();
        context.read<DSRCubit>().projectStatus = ProjectStatus.blockers;
        statusInt = 2;
        setState(() => blockersIsActive = true);
        break;
    }
  }

  void setDefaultStatus() {
    statusInt = widget.task.status;
    switch (widget.task.status) {
      case 0:
        context.read<DSRCubit>().projectStatus = ProjectStatus.done;
        doneIsActive = true;
        break;
      case 1:
        context.read<DSRCubit>().projectStatus = ProjectStatus.doing;
        doingIsActive = true;
        break;
      case 2:
        context.read<DSRCubit>().projectStatus = ProjectStatus.blockers;
        blockersIsActive = true;
        break;
    }
  }

  void save() {
    context.read<DSRCubit>().setProject(projectTag ?? projectList[0]);
    context.read<DSRCubit>().editTask(
          updatedTask: TaskCardDTO(
            taskName: textController.text,
            projectId: projectTag!.id,
            status: statusInt,
          ),
          oldTask: widget.task,
        );
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    context.read<DSRCubit>().getAllProjects();
    textController.text = widget.task.taskName;
    setDefaultStatus();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<DSRCubit, DSRState>(
      listenWhen: (DSRState previous, DSRState current) =>
          current is FetchProjectsSuccess,
      listener: (BuildContext context, DSRState state) {
        if (state is FetchProjectsSuccess) {
          setState(() {
            projectList = state.projects;
            projectTag = projectList.firstWhere(
              (Project element) => element.id == widget.task.projectId,
            );
          });
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.back),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Task Information',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 17),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Description ',
                    fillColor: formBackgroundColor,
                    filled: true,
                    enabledBorder: descriptionBorder,
                    border: descriptionBorder,
                    focusedBorder: descriptionBorder,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: formBackgroundColor,
                ),
                child: DropdownButton<Project>(
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  hint: LinearProgressIndicator(
                    minHeight: 1,
                    color: Colors.black26,
                    backgroundColor: formBackgroundColor,
                  ),
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  underline: const SizedBox.shrink(),
                  dropdownColor: Colors.white,
                  onChanged: (Project? value) {
                    setState(() {
                      projectTag = value;
                    });
                  },
                  value: projectTag,
                  items: projectList
                      .map<DropdownMenuItem<Project>>((Project value) {
                    return DropdownMenuItem<Project>(
                      value: value,
                      child: Text(value.projectName),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => updateStatus(ProjectStatus.done),
                    child: StatusChips(
                      status: TaskStatus.done,
                      isActive: doneIsActive,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => updateStatus(ProjectStatus.doing),
                    child: StatusChips(
                      status: TaskStatus.doing,
                      isActive: doingIsActive,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => updateStatus(ProjectStatus.blockers),
                    child: StatusChips(
                      status: TaskStatus.blockers,
                      isActive: blockersIsActive,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Remove Task',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ),
              Text(
                'This task will be permanently removed from your Daily Standup Report.',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(
                width: width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      theme.colorScheme.error.withAlpha(40),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<DSRCubit>().deleteTask(widget.task);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete Task',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: width,
                    margin: EdgeInsets.only(bottom: height * 0.03),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: projectTag == null ? null : save,
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
