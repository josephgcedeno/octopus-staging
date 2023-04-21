import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_date_picker.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_task_button.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';

class AccomplishmentsTasksList extends StatefulWidget {
  const AccomplishmentsTasksList({
    required this.reportTask,
    Key? key,
  }) : super(key: key);

  final void Function(Map<String, List<Map<String, String>>>) reportTask;

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

  List<String> selectedCategories = <String>[
    'done',
  ];

  Map<String, List<Map<String, String>>> selectedTasks =
      <String, List<Map<String, String>>>{};

  Map<String, List<Map<String, String>>> tasks =
      <String, List<Map<String, String>>>{};

  void _setTodayData() {
    tasks = <String, List<Map<String, String>>>{
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
  }

  void _setOtherDayData() {
    tasks = <String, List<Map<String, String>>>{};
  }

  void _selectDateToday() {
    setState(() {
      _selectedDate = DateTime.now();
      isToday = true;
      _setTodayData();
    });
  }

  void _handleDateSelection(DateTime date) {
    setState(() {
      isToday = false;
      _selectedDate = date;
      _setOtherDayData();
    });
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        if (selectedCategories.length != 1) {
          selectedCategories.remove(category);
        }
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void toggleTask(String task, String entry) {
    setState(() {
      if (tasks.isNotEmpty) {
        if (selectedTasks.isNotEmpty && selectedTasks.containsKey(entry)) {
          final bool containsText = selectedTasks[entry]!.any(
            (Map<String, String> item) => item['text'] == task,
          );

          if (containsText) {
            selectedTasks[entry]?.removeWhere(
              (Map<String, String> item) => item['text'] == task,
            );
            tasks[entry]!.add(<String, String>{'text': task});
            selectedTasks.removeWhere(
                (String key, List<Map<String, String>> item) => item.isEmpty);
          } else {
            selectedTasks[entry]?.add(<String, String>{'text': task});
            tasks[entry]!.removeWhere(
              (Map<String, String> item) => item['text'] == task,
            );
          }
        } else {
          selectedTasks.putIfAbsent(
            entry,
            () => <Map<String, String>>[
              <String, String>{'text': task},
            ],
          );
          tasks[entry]!
              .removeWhere((Map<String, String> item) => item['text'] == task);
        }
      }
    });
  }

  bool shouldShowTask(Map<String, String> task) {
    for (final String category in selectedCategories) {
      if (tasks.isNotEmpty && tasks[category]!.contains(task)) {
        return false;
      }
    }
    return true;
  }

  bool shouldShowSelectedTask(Map<String, String> task) {
    for (final String category in selectedCategories) {
      if (tasks.isNotEmpty && tasks[category]!.contains(task)) {
        return true;
      }
    }
    return false;
  }

  bool shouldShowTaskstoAdd() {
    if (selectedCategories.isNotEmpty) {
      for (int i = 0; i < selectedCategories.length; i++) {
        final String selectedCategory = selectedCategories[i];
        if (tasks.isNotEmpty && tasks[selectedCategory]!.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  bool shouldHighlightButton(String category) {
    if (selectedCategories.isNotEmpty) {
      if (selectedCategories.contains(category)) {
        if (selectedCategories.length == 1) {
          return true;
        }
        return true;
      } else if (selectedCategories.contains(category)) {
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    toggleCategory('done');
    _setTodayData();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      widget.reportTask(selectedTasks);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final String formattedDate = DateFormat('EEE, MMM d').format(_selectedDate);
    final bool showSelectedTasks = selectedTasks.isNotEmpty &&
        selectedTasks.values.any(
          (List<Map<String, String>> list) => list.isNotEmpty,
        );

    final List<Widget> selectedTaskWidgets = <Widget>[];
    final List<Widget> taskWidgets = <Widget>[];

    for (final MapEntry<String, List<Map<String, String>>> entry
        in selectedTasks.entries) {
      if (showSelectedTasks &&
          selectedTasks[entry.key]!.isNotEmpty &&
          selectedTasks.length > 1) {
        selectedTaskWidgets.add(
          Text(
            entry.key.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
      for (final Map<String, String> selectedTask in entry.value) {
        if (shouldShowSelectedTask(selectedTask)) {
          selectedTaskWidgets.add(const SizedBox.shrink());
        } else {
          selectedTaskWidgets.add(
            GestureDetector(
              onTap: () {
                toggleTask(selectedTask['text']!, entry.key);
              },
              child: AccomplishmentsTaskChecker(
                title: selectedTask['text']!,
                type: CheckerType.selected,
              ),
            ),
          );
        }
      }
    }

    for (final MapEntry<String, List<Map<String, String>>> entry
        in tasks.entries) {
      if (selectedCategories.contains(entry.key) &&
          selectedCategories.length > 1) {
        taskWidgets.add(
          Text(
            entry.key.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
      for (final Map<String, String> task in entry.value) {
        if (shouldShowTask(task)) {
          taskWidgets.add(const SizedBox.shrink());
        } else {
          taskWidgets.add(
            GestureDetector(
              onTap: () {
                toggleTask(task['text']!, entry.key);
              },
              child: AccomplishmentsTaskChecker(
                title: task['text']!,
                type: CheckerType.unselected,
              ),
            ),
          );
        }
      }
    }

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
                    onTap: _selectDateToday,
                    child: Icon(
                      Icons.today_outlined,
                      color: isToday ? theme.primaryColor : kDarkGrey,
                    ),
                  ),
                  AccomplishmentsDatePicker(
                    onDateSelected: _handleDateSelection,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 10,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      toggleCategory('done');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Done',
                      isClicked: shouldHighlightButton('done'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleCategory('doing');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Doing',
                      isClicked: shouldHighlightButton('doing'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleCategory('blockers');
                    },
                    child: AccomplishmentTaskButton(
                      title: 'Blocked',
                      isClicked: shouldHighlightButton('blockers'),
                    ),
                  ),
                ],
              ),
              if (showSelectedTasks)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.010),
                  child: const Text('Added tasks'),
                ),
              if (selectedTasks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedTaskWidgets.toList(),
                ),
              Visibility(
                visible: showSelectedTasks & shouldShowTaskstoAdd(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Divider(
                      height: 4,
                      color: kDarkGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.014),
                      child: const Text('Select tasks to add'),
                    ),
                  ],
                ),
              ),
              if (tasks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: taskWidgets.toList(),
                ),
              if (tasks.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(height * 0.015),
                        child: const Icon(
                          Icons.error_outline_outlined,
                        ),
                      ),
                      const Text('No data available'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
