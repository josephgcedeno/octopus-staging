import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/status_chips.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key}) : super(key: key);
  static const String routeName = '/edit_task';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final OutlineInputBorder descriptionBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10),
  );

  Color formBackgroundColor = const Color(0xFFf5f7f9);
  List<String> projectList = <String>[
    'Project Octopus',
    'NFTDeals-blocsport1',
    'FrontRx',
    'Metapad'
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter task',
                filled: true,
                fillColor: formBackgroundColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: formBackgroundColor,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Project'),
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                underline: const SizedBox.shrink(),
                dropdownColor: Colors.white,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  // setState(() {
                  //   dropdownValue = value!;
                  // });
                },
                items:
                    projectList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Row(
              children: const <Widget>[
                StatusChips(status: TaskStatus.doing),
                StatusChips(status: TaskStatus.done),
                StatusChips(status: TaskStatus.blockers),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                maxLines: 8,
                minLines: 8,
                decoration: InputDecoration(
                  hintText: 'Description',
                  fillColor: formBackgroundColor,
                  filled: true,
                  enabledBorder: descriptionBorder,
                  border: descriptionBorder,
                  focusedBorder: descriptionBorder,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(theme.errorColor.withAlpha(40)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Delete Task',
                  style: theme.textTheme.bodyText2
                      ?.copyWith(color: theme.errorColor),
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
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
