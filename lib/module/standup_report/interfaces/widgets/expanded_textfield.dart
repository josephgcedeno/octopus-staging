import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class ExpandedTextField extends StatefulWidget {
  const ExpandedTextField({Key? key}) : super(key: key);

  @override
  State<ExpandedTextField> createState() => _ExpandedTextFieldState();
}

class _ExpandedTextFieldState extends State<ExpandedTextField> {
  TextEditingController textController = TextEditingController();
  bool projectIsActive = false;
  bool statusIsActive = false;
  bool projectHasBeenSet = false;
  bool statusHasBeenSet = false;

  void save() {
    if (projectHasBeenSet && statusHasBeenSet) {
      context.read<DSRCubit>().updateTasks(taskLabel: textController.text);
      textController.clear();
    } else {
      final String textFieldValue = textController.text.trim();
      String errorText;
      if (textFieldValue.isEmpty) {
        errorText = 'Task Name cannot be empty.';
      } else {
        errorText = 'Project and Task Status has to be set.';
      }
      showSnackBar(
        message: errorText,
        snackBartState: SnackBartState.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocListener<DSRCubit, DSRState>(
      listenWhen: (DSRState previous, DSRState current) =>
          current is ShowProjectPane ||
          current is ShowStatusPane ||
          current is HideProjectPane ||
          current is HideStatusPane,
      listener: (BuildContext context, DSRState state) {
        if (state is ShowStatusPane || state is HideStatusPane) {
          projectIsActive = false;
          setState(() => statusIsActive = !statusIsActive);
        } else if (state is ShowProjectPane || state is HideProjectPane) {
          statusIsActive = false;
          setState(() => projectIsActive = !projectIsActive);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFf5f7f9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter task name',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<DSRCubit>()
                                .toggleProjectPane(isVisible: !projectIsActive);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          icon: RotatedBox(
                            quarterTurns: -1,
                            child: Icon(
                              Icons.view_stream_outlined,
                              color: projectIsActive
                                  ? theme.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          label: BlocBuilder<DSRCubit, DSRState>(
                            buildWhen: (DSRState previous, DSRState current) =>
                                current is SetProjectSuccess,
                            builder: (BuildContext context, DSRState state) {
                              if (state is SetProjectSuccess) {
                                projectHasBeenSet = true;
                                return Text(
                                  state.project.projectName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: projectIsActive
                                        ? theme.primaryColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }
                              return Text(
                                'Project',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: projectIsActive
                                      ? theme.primaryColor
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<DSRCubit>()
                                .toggleStatusPane(isVisible: !statusIsActive);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          icon: Icon(
                            Icons.padding_outlined,
                            color: statusIsActive
                                ? theme.primaryColor
                                : Colors.grey,
                          ),
                          label: BlocBuilder<DSRCubit, DSRState>(
                            buildWhen: (DSRState previous, DSRState current) =>
                                current is UpdateTaskStatus,
                            builder: (BuildContext context, DSRState state) {
                              if (state is UpdateTaskStatus) {
                                statusHasBeenSet = true;
                                return Text(
                                  state.status,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: statusIsActive
                                        ? theme.primaryColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }
                              return Text(
                                'Status',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: statusIsActive
                                      ? theme.primaryColor
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                    bottom: 2,
                  ),
                  child: ElevatedButton(
                    onPressed: save,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        theme.primaryColor,
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
