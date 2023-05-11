import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/daily_accomplishment_report_screen.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_tasks_slider_and_list.dart';
import 'package:octopus/module/accomplishments_generator/service/cubit/accomplishments_cubit.dart';

class AccomplishmentsGeneratorScreen extends StatefulWidget {
  const AccomplishmentsGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<AccomplishmentsGeneratorScreen> createState() =>
      _AccomplishmentsGeneratorScreenState();
}

class _AccomplishmentsGeneratorScreenState
    extends State<AccomplishmentsGeneratorScreen> {
  late Map<String, List<DSRWorks>>? selectedTasks;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Accomplishment Generator',
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium,
                      ),
                    ),
                    const AccomplishmentsSliderAndTasksList(),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    selectedTasks = context
                        .read<AccomplishmentsCubit>()
                        .state
                        .selectedTasks;
                    if (selectedTasks != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute<dynamic>(
                          builder: (_) =>
                              const DailyAccomplishmentReportScreen(),
                        ),
                      );
                    } else {
                      showSnackBar(
                        message: 'Please select a task before proceeding.',
                        snackBartState: SnackBartState.error,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.02,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.04,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Proceed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}