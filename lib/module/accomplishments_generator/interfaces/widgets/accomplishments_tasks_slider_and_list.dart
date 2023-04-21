import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_date_picker.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_dots_indicator.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_project_card.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_task_button.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';

class AccomplishmentsSliderAndTasksList extends StatefulWidget {
  const AccomplishmentsSliderAndTasksList({
    required this.reportTask,
    Key? key,
  }) : super(key: key);

  final void Function(Map<String, List<Map<String, String>>>) reportTask;

  @override
  State<AccomplishmentsSliderAndTasksList> createState() =>
      _AccomplishmentsSliderAndTasksListState();
}

class _AccomplishmentsSliderAndTasksListState
    extends State<AccomplishmentsSliderAndTasksList> {
  bool displayTitle = false;
  bool isToday = true;
  bool isClicked = false;

  String buttonClicked = 'done';
  DateTime _selectedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  final PageController _pageController = PageController(
    viewportFraction: 0.9,
  );
  int _currentPageIndex = 0;

  List<String> selectedCategories = <String>[
    'done',
  ];

  Map<String, List<Map<String, String>>> selectedTasks =
      <String, List<Map<String, String>>>{};

  Map<String, List<Map<String, String>>> tasks =
      <String, List<Map<String, String>>>{};

  final List<Map<String, Object>> projects = <Map<String, Object>>[
    <String, Object>{
      'name': 'Project Octopus',
      'backgroundColor': kBlue,
      'textColor': kWhite,
      'image': SvgPicture.asset(whiteLogoSvg),
    },
    <String, Object>{
      'name': 'Coin Mode',
      'backgroundColor': Colors.orange,
      'textColor': kWhite,
      'image': Image.network(
        'https://cdn-icons-png.flaticon.com/512/7880/7880066.png',
      ),
    },
    <String, Object>{
      'name': 'NFT Deals',
      'backgroundColor': kLightGrey,
      'textColor': kBlack,
      'image': Image.network(
        'https://cdn-icons-png.flaticon.com/512/6699/6699362.png',
      ),
    },
  ];

  void _setData() {
    if (_currentPageIndex == 0) {
      _setTodayData();
      return;
    }
    _setOtherDayData();
  }

  void _setTodayData() {
    setState(() {
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
    });
  }

  void _setOtherDayData() {
    setState(() {
      tasks = <String, List<Map<String, String>>>{};
    });
  }

  void _selectDateToday() {
    setState(() {
      _selectedDate = DateTime.now();
      isToday = true;
      _setData();
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
              (String key, List<Map<String, String>> item) => item.isEmpty,
            );
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
    _setData();
    _pageController.addListener(() {
      setState(() {
        _setData();
        _currentPageIndex = _pageController.page!.round();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
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
      if (tasks[entry.key]!.isNotEmpty &&
          selectedCategories.contains(entry.key) &&
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: height * 0.03),
              height: height * 0.2,
              child: PageView(
                controller: _pageController,
                clipBehavior: Clip.none,
                physics: const PageScrollPhysics(),
                children: projects.map((Map<String, Object> project) {
                  final Color? textColor = project['textColor'] as Color?;
                  final Color? backgroundColor =
                      project['backgroundColor'] as Color?;
                  final Widget image = project['image']! as Widget;

                  return AccomplishmentsProjectCard(
                    title: project['name']! as String,
                    image: image,
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                  );
                }).toList(),
              ),
            ),
            DotsIndicator(
              currentIndex: _currentPageIndex,
              pageCount: projects.length,
            ),
          ],
        ),
        Padding(
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
                      AccomplishmentTaskButton(
                        title: 'Done',
                        onPressed: () => toggleCategory('done'),
                        isClicked: shouldHighlightButton('done'),
                      ),
                      AccomplishmentTaskButton(
                        title: 'Doing',
                        onPressed: () => toggleCategory('doing'),
                        isClicked: shouldHighlightButton('doing'),
                      ),
                      AccomplishmentTaskButton(
                        title: 'Blocked',
                        onPressed: () => toggleCategory('blockers'),
                        isClicked: shouldHighlightButton('blockers'),
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
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.014),
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
        ),
      ],
    );
  }
}
