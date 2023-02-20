import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/time_record/interfaces/widgets/details.dart';
import 'package:octopus/module/time_record/interfaces/widgets/dtr_clock.dart';
import 'package:octopus/module/time_record/interfaces/widgets/offset_button.dart';
import 'package:octopus/module/time_record/interfaces/widgets/time_record_slider.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class TimeRecordScreen extends StatefulWidget {
  const TimeRecordScreen({Key? key}) : super(key: key);

  static const String routeName = '/time_record';

  @override
  State<TimeRecordScreen> createState() => _TimeRecordScreenState();
}

class _TimeRecordScreenState extends State<TimeRecordScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TimeRecordCubit>().fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.menu),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.03),
                child: Text(
                  'Daily Time Record',
                  style: kIsWeb
                      ? theme.textTheme.headline6
                      : theme.textTheme.subtitle1,
                ),
              ),
            ),
            DTRClock(
              key: UniqueKey(),
            ),
            const DTRDetails(),
            const OffsetButton(),
            const TimeInSlider()
          ],
        ),
      ),
    );
  }
}
