import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/time_record/interfaces/widgets/details.dart';
import 'package:octopus/module/time_record/interfaces/widgets/dtr_clock.dart';
import 'package:octopus/module/time_record/interfaces/widgets/offset_button.dart';
import 'package:octopus/module/time_record/interfaces/widgets/time_record_slider.dart';

class TimeRecordScreen extends StatefulWidget {
  const TimeRecordScreen({Key? key}) : super(key: key);

  static const String routeName = '/time_record';

  @override
  State<TimeRecordScreen> createState() => _TimeRecordScreenState();
}

class _TimeRecordScreenState extends State<TimeRecordScreen> {
  Future<bool> timeInTimeOut(DismissDirection dir) async {
    if (timeInEpoch == -1) {
      setState(() {
        timeInEpoch = DateTime.now().millisecondsSinceEpoch;
      });
    } else {
      setState(() => timeInEpoch = -1);
    }
    return false;
  }

  int timeInEpoch = -1;

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
              timeInEpoch: timeInEpoch,
              key: UniqueKey(),
            ),
            const DTRDetails(),
            const OffsetButton(),
            TimeInSlider(
              onSlide: timeInTimeOut,
              timeInEpoch: timeInEpoch,
            )
          ],
        ),
      ),
    );
  }
}
