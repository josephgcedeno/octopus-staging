import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/infrastructures/models/project/project_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_date_picker.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_dots_indicator.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_project_card.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_task_button.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_checker.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';

class AccomplishmentsSliderAndTasksList extends StatefulWidget {
  const AccomplishmentsSliderAndTasksList({
    Key? key,
  }) : super(key: key);

  @override
  State<AccomplishmentsSliderAndTasksList> createState() =>
      _AccomplishmentsSliderAndTasksListState();
}

class _AccomplishmentsSliderAndTasksListState
    extends State<AccomplishmentsSliderAndTasksList> {
  bool displayTitle = false;
  bool isToday = true;
  bool isClicked = false;
  bool isLoading = true;

  String buttonClicked = 'done';
  String projectID = '';
  DateTime _selectedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  final PageController _pageController = PageController(
    viewportFraction: 0.9,
  );
  int _currentPageIndex = 0;

  List<String> selectedCategories = <String>[
    'done',
  ];

  // Map<String, List<Map<String, String>>> selectedTasks =
  //     <String, List<Map<String, String>>>{};

  Map<String, List<DSRWorks>> tasks = <String, List<DSRWorks>>{};

  Map<String, List<DSRWorks>> selectedTasks = <String, List<DSRWorks>>{};

  List<Project> projects = <Project>[];

  final List<Widget> selectedTaskWidgets = <Widget>[];
  final List<Widget> taskWidgets = <Widget>[];

  bool shouldShowTask(DSRWorks task) {
    for (String category in selectedCategories) {
      category = convertCategory(category);
      if (tasks.isNotEmpty && tasks.containsKey(category)) {
        if (tasks[category]!.contains(task)) {
          return false;
        }
      }
    }
    return true;
  }

  bool shouldShowSelectedTask(DSRWorks task) {
    for (String category in selectedCategories) {
      category = convertCategory(category);
      if (selectedTasks.isNotEmpty && selectedTasks.containsKey(category)) {
        if (selectedTasks[category]!.contains(task)) {
          return false;
        }
        return false;
      }
    }
    return true;
  }

  bool shouldShowTaskstoAdd() {
    if (selectedCategories.isNotEmpty) {
      for (int i = 0; i < selectedCategories.length; i++) {
        String selectedCategory = selectedCategories[i];
        selectedCategory = convertCategory(selectedCategory);
        if (tasks.isNotEmpty && tasks.containsKey(selectedCategory)) {
          if (tasks[selectedCategory]!.isNotEmpty) {
            return true;
          }
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

  bool shouldProjectDateChange() {
    if (projects.isNotEmpty) {
      if (selectedTasks.isNotEmpty &&
          selectedTasks.values.any(
            (List<DSRWorks> category) => category.isNotEmpty,
          )) {
        return false;
      }
      return true;
    }
    return false;
  }

  String convertCategory(String category) {
    if (category == 'doing') {
      return 'work_in_progress';
    }

    return category;
  }

  // void _setData() {
  //   if (_currentPageIndex == 0) {
  //     _setTodayData();
  //     return;
  //   }
  //   // _setOtherDayData();
  // }

  // void _setTodayData() {
  //   // setState(() {
  //   //   tasks = <String, List<Map<String, String>>>{
  //   //     'done': <Map<String, String>>[
  //   //       <String, String>{'text': 'Deploy eleven minions'},
  //   //       <String, String>{'text': 'Deploy nine minions'},
  //   //       <String, String>{'text': 'Deploy two minions'},
  //   //       <String, String>{'text': 'Deploy eight minions'},
  //   //       <String, String>{'text': 'Deploy eleven minions'},
  //   //       <String, String>{'text': 'Deploy ten minions'}
  //   //     ],
  //   //     'doing': <Map<String, String>>[
  //   //       <String, String>{'text': 'Deploy eight minions'},
  //   //       <String, String>{'text': 'Deploy seven minions'},
  //   //       <String, String>{'text': 'Deploy two minions'},
  //   //     ],
  //   //     'blockers': <Map<String, String>>[
  //   //       <String, String>{'text': 'Deploy four minions'},
  //   //       <String, String>{'text': 'Deploy six minions'}
  //   //     ],
  //   //   };
  //   // });
  // }

  // void _setOtherDayData() {
  //   // setState(() {
  //   //   tasks = <String, List<Map<String, String>>>{};
  //   // });
  // }

  void _selectDateToday() {
    if (shouldProjectDateChange()) {
      setState(() {
        _selectedDate = DateTime.now();
        isToday = true;
      });
      context
          .read<AccomplishmentsCubit>()
          .getAccomplishments(_selectedDate, _currentPageIndex);
    }
  }

  void _handleDateSelection(DateTime date) {
    setState(() {
      isToday = false;
      _selectedDate = date;
      // _setOtherDayData();
    });
    context
        .read<AccomplishmentsCubit>()
        .getAccomplishments(_selectedDate, _currentPageIndex);
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

  void toggleTask(DSRWorks task, String category) {
    setState(() {
      if (tasks.isNotEmpty) {
        if (selectedTasks.isNotEmpty && selectedTasks.containsKey(category)) {
          final bool containsText = selectedTasks[category]!.any(
            (DSRWorks item) => item == task,
          ); // checks whether selectedTasks already has the task

          if (containsText) {
            selectedTasks.remove(task);
            selectedTasks[category]!.removeWhere(
              (DSRWorks item) => item == task,
            );
            selectedTasks
                .removeWhere((String key, List<DSRWorks> item) => item.isEmpty);
            tasks[category]!.add(task);
          } else {
            tasks[category]!.removeWhere(
              (DSRWorks item) => item == task,
            );
            selectedTasks[category]!.add(task);
          }
        } else {
          selectedTasks[category] ??= <DSRWorks>[];
          selectedTasks[category]!.add(task);
          tasks[category]!.remove(task);
        }
      }
      context.read<AccomplishmentsCubit>().getSelectedTasks(selectedTasks);
    });
  }

  void _updateProjects(int newIndex) {
    setState(() {
      _currentPageIndex = newIndex;
      selectedTasks.clear();
    });
    context
        .read<AccomplishmentsCubit>()
        .getAccomplishments(_selectedDate, _currentPageIndex);
  }

  @override
  void initState() {
    context
        .read<AccomplishmentsCubit>()
        .getAccomplishments(_selectedDate, _currentPageIndex);

    _pageController.addListener(() {
      setState(() {
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final String formattedDate = DateFormat('EEE, MMM d').format(_selectedDate);
    final bool showSelectedTasks = selectedTasks.isNotEmpty &&
        selectedTasks.values.any(
          (List<DSRWorks> category) => category.isNotEmpty,
        );

    final Iterable<MapEntry<String, List<DSRWorks>>> iterableTasks =
        tasks.entries;

    final Iterable<MapEntry<String, List<DSRWorks>>> iterableSelectedTasks =
        selectedTasks.entries;

    for (final MapEntry<String, List<DSRWorks>> entry in iterableTasks) {
      String category = entry.key;
      if (category == 'work_in_progress') {
        category = 'doing';
      }
      if (tasks[entry.key]!.isNotEmpty &&
          selectedCategories.contains(category) &&
          selectedCategories.length > 1) {
        taskWidgets.add(
          Text(
            category.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
      for (final DSRWorks task in entry.value) {
        if (shouldShowTask(task)) {
          taskWidgets.add(const SizedBox.shrink());
        } else {
          taskWidgets.add(
            AccomplishmentsTaskChecker(
              title: task.text,
              type: CheckerType.unselected,
              onTap: () {
                toggleTask(task, entry.key);
              },
            ),
          );
        }
      }
    }

    for (final MapEntry<String, List<DSRWorks>> entry
        in iterableSelectedTasks) {
      String category = entry.key;
      if (category == 'work_in_progress') {
        category = 'doing';
      }
      if (showSelectedTasks &&
          selectedTasks[entry.key]!.isNotEmpty &&
          selectedTasks.length > 1) {
        selectedTaskWidgets.add(
          Text(
            category.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
      for (final DSRWorks selectedTask in entry.value) {
        if (shouldShowSelectedTask(selectedTask)) {
          selectedTaskWidgets.add(const SizedBox.shrink());
        } else {
          selectedTaskWidgets.add(
            AccomplishmentsTaskChecker(
              title: selectedTask.text,
              type: CheckerType.selected,
              onTap: () {
                toggleTask(selectedTask, entry.key);
              },
            ),
          );
        }
      }
    }

    return BlocListener<AccomplishmentsCubit, AccomplishmentsState>(
      listenWhen:
          (AccomplishmentsState previous, AccomplishmentsState current) =>
              current is FetchAllAccomplishmentsDataLoading ||
              current is FetchAllAccomplishmentsDataSuccess ||
              current is FetchAllAccomplishmentsDataFailed,
      listener: (BuildContext context, AccomplishmentsState state) {
        if (state is FetchAllAccomplishmentsDataLoading) {}
        if (state is FetchAllAccomplishmentsDataSuccess) {
          setState(() {
            isLoading = false;
            projects = state.projects;
            tasks = state.tasks;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isLoading) sliderLoader(context),
          if (!isLoading)
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: height * 0.03),
                  height: height * 0.2,
                  child: PageView(
                    controller: _pageController,
                    clipBehavior: Clip.none,
                    onPageChanged: _updateProjects,
                    physics: shouldProjectDateChange() && projects.length > 1
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    children: projects.map((Project project) {
                      projectID = project.id;
                      return AccomplishmentsProjectCard(
                        title: project.projectName,
                        image: SvgPicture.asset(
                          whiteLogoSvg,
                        ), // change to project.logo (depending on the name) if available
                        textColor:
                            kWhite, // change to project.textColor (depending on the name) if available
                        backgroundColor: Color(int.parse(project.color)),
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
                          shouldProjectDateChange: shouldProjectDateChange(),
                          isClicked: !isToday,
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
                    BlocBuilder<AccomplishmentsCubit, AccomplishmentsState>(
                      buildWhen: (
                        AccomplishmentsState previous,
                        AccomplishmentsState current,
                      ) =>
                          current is FetchAllAccomplishmentsDataLoading ||
                          current is FetchAllAccomplishmentsDataSuccess,
                      builder:
                          (BuildContext context, AccomplishmentsState state) {
                        if (state is FetchAllAccomplishmentsDataLoading) {
                          return tasksLoader(context);
                        } else if (state
                            is FetchAllAccomplishmentsDataSuccess) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (tasks.isEmpty && selectedTasks.isEmpty)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(height * 0.02),
                                        child: const Icon(
                                          Icons.error_outline_outlined,
                                        ),
                                      ),
                                      const Text('No data available'),
                                    ],
                                  ),
                                ),
                              ...taskWidgets.toList(),
                            ],
                          );
                        }
                        return const Placeholder();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
