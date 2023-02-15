import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
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
                          statusIsActive = false;
                          setState(() => projectIsActive = !projectIsActive);
                          context
                              .read<DSRCubit>()
                              .toggleProjectPane(isVisible: projectIsActive);
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
                        label: Text(
                          'Project',
                          style: theme.textTheme.bodyText2?.copyWith(
                            color: projectIsActive
                                ? theme.primaryColor
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          projectIsActive = false;
                          setState(() => statusIsActive = !statusIsActive);
                          context
                              .read<DSRCubit>()
                              .toggleStatusPane(isVisible: statusIsActive);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        icon: Icon(
                          Icons.padding_outlined,
                          color:
                              statusIsActive ? theme.primaryColor : Colors.grey,
                        ),
                        label: Text(
                          'Status',
                          style: theme.textTheme.bodyText2?.copyWith(
                            color: statusIsActive
                                ? theme.primaryColor
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
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
                  onPressed: () {
                    // context
                    //     .read<DSRCubit>()
                    //     .updateTasks(taskLabel: textController.text);
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      theme.primaryColor,
                    ),
                    // padding: MaterialStateProperty.all(
                    //   const EdgeInsets.all(18),
                    // ),
                  ),
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
