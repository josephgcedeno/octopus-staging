import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_task_button.dart';

class AccomplishmentsTasksList extends StatefulWidget {
  const AccomplishmentsTasksList({Key? key}) : super(key: key);

  @override
  State<AccomplishmentsTasksList> createState() =>
      _AccomplishmentsTasksListState();
}

class _AccomplishmentsTasksListState extends State<AccomplishmentsTasksList> {
  bool displayTitle = false;
  bool isToday = true;
  bool isClicked = false;

  String buttonClicked = 'done';
  DateTime _selectedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  List<String> selectedCategories = <String>[];

  void _selectPreviousDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _selectNextDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  bool shouldShowTask(Map<String, String> task) {
    for (final String category in selectedCategories) {
      if (tasks[category]!.contains(task)) {
        return true;
      }
    }
    return false;
  }

  final Map<String, List<Map<String, String>>> tasks =
      const <String, List<Map<String, String>>>{
    'done': <Map<String, String>>[
      <String, String>{'text': 'Deploy eleven minions'},
      <String, String>{'text': 'Deploy nine minions'},
      <String, String>{'text': 'Deploy two minions'},
      <String, String>{'text': 'Deploy eight minions'},
      <String, String>{'text': 'Deploy eleven minions'},
      <String, String>{'text': 'Deploy ten minions'}
    ],
    'doing': <Map<String, String>>[
      <String, String>{'text': 'Deploy eight minions'},
      <String, String>{'text': 'Deploy seven minions'},
      <String, String>{'text': 'Deploy two minions'},
    ],
    'blockers': <Map<String, String>>[
      <String, String>{'text': 'Deploy four minions'},
      <String, String>{'text': 'Deploy six minions'}
    ],
  };

  @override
  void initState() {
    toggleCategory('done');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final String formattedDate = DateFormat('EEE, MMM d').format(_selectedDate);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: (_selectedDate.year == _today.year &&
                              _selectedDate.month == _today.month &&
                              _selectedDate.day == _today.day)
                          ? 'Today'
                          : formattedDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "'s Task",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _selectPreviousDate,
                    child: const Icon(
                      Icons.chevron_left_outlined,
                      color: kDarkGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: _selectNextDate,
                    child: const Icon(
                      Icons.chevron_right_outlined,
                      color: kDarkGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // const TaskList(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 10,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      toggleCategory('done');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Done',
                      isClicked: selectedCategories.contains('done'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      toggleCategory('doing');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Doing',
                      isClicked: selectedCategories.contains('doing'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      toggleCategory('blockers');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Blocked',
                      isClicked: selectedCategories.contains('blockers'),
                    ),
                  ),
                ],
              ),
              ...tasks.entries
                  .expand(
                    (MapEntry<String, List<Map<String, String>>> entry) =>
                        entry.value.map((Map<String, String> task) {
                      if (!shouldShowTask(task)) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  minRadius: width * 0.04,
                                  maxRadius: width * 0.04,
                                  backgroundImage: const NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.03),
                                  child: Text(task['text']!),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isClicked = !isClicked;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(width * 0.01),
                                decoration: BoxDecoration(
                                  color: isClicked
                                      ? kLightRed.withOpacity(0.08)
                                      : kAqua.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isClicked
                                    ? const Icon(Icons.close, color: kLightRed)
                                    : const Icon(Icons.check, color: kAqua),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
