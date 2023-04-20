import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_date_picker.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_task_button.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';

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

  List<String> selectedCategories = <String>[
    'done',
  ];

  Map<String, List<Map<String, String>>> selectedTasks =
      <String, List<Map<String, String>>>{
    'done': <Map<String, String>>[],
    'doing': <Map<String, String>>[],
    'blockers': <Map<String, String>>[]
  };

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
    tasks = {};
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
                (Map<String, String> item) => item['text'] == task);
            tasks[entry]!.add(<String, String>{'text': task});
          } else {
            selectedTasks[entry]?.add(<String, String>{'text': task});
            tasks[entry]!.removeWhere(
                (Map<String, String> item) => item['text'] == task);
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final String formattedDate = DateFormat('EEE, MMM d').format(_selectedDate);
    final bool showSelectedTasks = selectedTasks.isNotEmpty &&
        selectedTasks.values.any(
          (List<Map<String, String>> list) => list.isNotEmpty,
        );

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
                  padding: EdgeInsets.only(top: height * 0.010),
                  child: const Text('Added tasks'),
                ),
              ...selectedTasks.entries
                  .expand(
                    (MapEntry<String, List<Map<String, String>>> entry) =>
                        entry.value.map((Map<String, String> selectedtask) {
                      if (shouldShowSelectedTask(selectedtask)) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () {
                          toggleTask(selectedtask['text']!, entry.key);
                        },
                        child: AccomplishmentsTaskChecker(
                          title: selectedtask['text']!,
                          type: CheckerType.selected,
                        ),
                      );
                    }),
                  )
                  .toList(),
              Visibility(
                visible: showSelectedTasks & shouldShowTaskstoAdd(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: const Divider(
                        height: 4,
                        color: kDarkGrey,
                      ),
                    ),
                    const Text('Select tasks to add'),
                  ],
                ),
              ),
              if (tasks.isNotEmpty)
                ...tasks.entries
                    .expand(
                      (MapEntry<String, List<Map<String, String>>> entry) =>
                          entry.value.map((Map<String, String> task) {
                        if (shouldShowTask(task)) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            toggleTask(task['text']!, entry.key);
                          },
                          child: AccomplishmentsTaskChecker(
                            title: task['text']!,
                            type: CheckerType.unselected,
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
