import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/details.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/dtr_clock.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/offset_button.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/time_in_slider.dart';

class TimeInScreen extends StatefulWidget {
  const TimeInScreen({Key? key}) : super(key: key);

  static const String routeName = '/time_in';

  @override
  State<TimeInScreen> createState() => _TimeInScreenState();
}

class _TimeInScreenState extends State<TimeInScreen> {
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: width * 0.025),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.face,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    // top: height * 0.035,
                    bottom: height * 0.03,
                  ),
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
      ),
    );
  }
}
