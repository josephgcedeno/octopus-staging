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
  Future<bool> timeInTimeOut(DismissDirection dir) async {
    if (timeOutEpoch != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already in for the day'),
          backgroundColor: Colors.green,
        ),
      );
    }

    /// This condition will check to drag is TIME IN
    if (timeInEpoch == -1) {
      context.read<TimeRecordCubit>().signInToday();
    } else {
      /// This condition will check to drag is TIME OUT
      context.read<TimeRecordCubit>().signOutToday();
    }
    return false;
  }

  /// Set what time did the user time in.
  int timeInEpoch = -1;

  /// Set what is the required time for the user to render. Default is 8hr in Minute is 480.
  int requiredTimeInMinutes = 480;

  /// Set what time to did the user time out.
  int? timeOutEpoch;

  @override
  void initState() {
    super.initState();
    context.read<TimeRecordCubit>().fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<TimeRecordCubit, TimeRecordState>(
      listenWhen: (TimeRecordState previous, TimeRecordState current) =>
          current is FetchTimeInDataLoading ||
          current is FetchTimeInDataSuccess ||
          current is FetchTimeInDataFailed,
      listener: (BuildContext context, TimeRecordState state) {
        if (state is FetchTimeInDataLoading) {
        } else if (state is FetchTimeInDataSuccess) {
          setState(() {
            timeInEpoch = state.attendance.timeInEpoch ?? 0;
            requiredTimeInMinutes = state.attendance.requiredDuration ?? 0;
            timeOutEpoch = state.attendance.timeOutEpoch;
          });
        } else if (state is FetchTimeInDataFailed) {}
      },
      child: Scaffold(
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
                timeOutEpoch: timeOutEpoch,
                requiredTimeInMinutes: requiredTimeInMinutes,
                key: UniqueKey(),
              ),
              const DTRDetails(),
              const OffsetButton(),
              TimeInSlider(
                onSlide: timeInTimeOut,
                timeInEpoch: timeOutEpoch != null ? -1 : timeInEpoch,
              )
            ],
          ),
        ),
      ),
    );
  }
}
