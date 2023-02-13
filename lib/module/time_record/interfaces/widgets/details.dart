import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class DTRDetails extends StatefulWidget {
  const DTRDetails({Key? key}) : super(key: key);

  @override
  State<DTRDetails> createState() => _DTRDetailsState();
}

class _DTRDetailsState extends State<DTRDetails> {
  final List<String> labels = <String>[
    'Date today:',
    'Time In:',
    'Time Out:',
    'Overtime:',
    'Time to render:'
  ];

  final List<String> values = <String>[
    'January 18, 2023',
    '8:30 AM',
    '-----',
    '-----',
    '8 hours'
  ];

  void setInfo(Attendance info) {
    const String approved = 'APPROVED';

    /// Get the date to day and format it.
    final String dateToday = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    /// Get the time in record for the day if not null.
    final String timeIn = info.timeInEpoch != null
        ? DateFormat('h:mm a').format(
            dateTimeFromEpoch(
              epoch: info.timeInEpoch!,
            ),
          )
        : '-----';

    /// Get the time out record for the day if not null.
    final String timeOut = info.timeOutEpoch != null
        ? DateFormat('h:mm a').format(
            dateTimeFromEpoch(
              epoch: info.timeOutEpoch!,
            ),
          )
        : '-----';

    /// Get the over time record for the day if not null and if it is approved by the admin.
    final String overTime =
        info.offsetDuration != null && info.offsetStatus == approved
            ? printDurationFrom(
                Duration(minutes: info.offsetDuration!),
              )
            : '-----';

    /// Get the time to render for the day if not null.
    final String timeToRender = printDurationFrom(
      Duration(
        minutes: info.requiredDuration ?? 0,
      ),
    );

    /// Set all the info.
    setState(() {
      values[0] = dateToday;
      values[1] = timeIn;
      values[2] = timeOut;
      values[3] = overTime;
      values[4] = timeToRender;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<TimeRecordCubit, TimeRecordState>(
      listenWhen: (TimeRecordState previous, TimeRecordState current) =>
          current is FetchTimeInDataLoading ||
          current is FetchTimeInDataLoadingSuccess ||
          current is FetchTimeInDataLoadingFailed,
      listener: (BuildContext context, TimeRecordState state) {
        if (state is FetchTimeInDataLoading) {
        } else if (state is FetchTimeInDataLoadingSuccess) {
          setInfo(
            state.attendance,
          );
        } else if (state is FetchTimeInDataLoadingFailed) {}
      },
      child: Container(
        padding: EdgeInsets.only(
          top: height * 0.05,
          bottom: kIsWeb ? height * 0.03 : 0,
        ),
        width: kIsWeb ? 350 : width * 0.7,
        child: Column(
          children: <Widget>[
            for (int i = 0; i < 5; i++)
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      labels[i],
                      style: theme.textTheme.bodyText2
                          ?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      values[i],
                      style: theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
