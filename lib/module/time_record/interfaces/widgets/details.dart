import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/time_in_out/attendance_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
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

  final List<String> values = <String>['January 18, 2023', '', '', '', ''];

  void setInfo(Attendance? info) {

    const String approved = 'APPROVED';

    /// Get the time in record for the day if not null.
    final String timeIn = info?.timeInEpoch != null
        ? DateFormat('h:mm a').format(
            dateTimeFromEpoch(
              epoch: info?.timeInEpoch! ?? 0,
            ),
          )
        : '-----';

    /// Get the time out record for the day if not null.
    final String timeOut = info?.timeOutEpoch != null
        ? DateFormat('h:mm a').format(
            dateTimeFromEpoch(
              epoch: info?.timeOutEpoch! ?? 0,
            ),
          )
        : '-----';

    /// Get the over time record for the day if not null and if it is approved by the admin.
    final String overTime =
        info?.offsetDuration != null && info?.offsetStatus == approved
            ? printDurationFrom(
                Duration(minutes: info?.offsetDuration! ?? 0),
              )
            : '-----';

    /// Get the time to render for the day if not null.
    final String timeToRender = printDurationFrom(
      Duration(
        minutes: info?.requiredDuration ?? 480,
      ),
    );

    /// Set all the info.
    setState(() {
      values[1] = timeIn;
      values[2] = timeOut;
      values[3] = overTime;
      values[4] = timeToRender;
    });
  }

  @override
  void initState() {
    super.initState();
    values[0] = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<TimeRecordCubit, TimeRecordState>(
      listenWhen: (TimeRecordState previous, TimeRecordState current) =>
          current is FetchTimeInDataLoading ||
          current is FetchTimeInDataSuccess ||
          current is FetchTimeInDataFailed,
      listener: (BuildContext context, TimeRecordState state) {
        if (state is FetchTimeInDataLoading) {
          setState(() {
            values[1] = '';
            values[2] = '';
            values[3] = '';
            values[4] = '';
          });
        } else if (state is FetchTimeInDataSuccess) {
          setInfo(
            state.attendance,
          );
        } else if (state is FetchTimeInDataFailed) {}
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
                    if (values[i] == '')
                      lineLoader(height: 10, width: width * 0.15)
                    else
                      FadeIn(
                        duration: fadeInDuration,
                        child: Text(
                          values[i],
                          style: theme.textTheme.bodyText2,
                        ),
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
