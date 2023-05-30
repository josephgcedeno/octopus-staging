import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/dismissible_notification.dart';
import 'package:octopus/internal/class_parse_object.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:octopus/module/time_record/interfaces/widgets/details.dart';
import 'package:octopus/module/time_record/interfaces/widgets/dtr_clock.dart';
import 'package:octopus/module/time_record/interfaces/widgets/offset_button.dart';
import 'package:octopus/module/time_record/interfaces/widgets/time_record_slider.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TimeRecordScreen extends StatefulWidget {
  const TimeRecordScreen({Key? key}) : super(key: key);

  static const String routeName = '/time_record';

  @override
  State<TimeRecordScreen> createState() => _TimeRecordScreenState();
}

class _TimeRecordScreenState extends State<TimeRecordScreen> {
  final LiveQuery liveQuery = LiveQuery();
  Subscription<TimeAttendancesParseObject>? subscription;
  Widget? notificationDialog;

  /// TODO: better to move up to much globally accessable listener. Like global scaffold to trigger like a notification.
  Future<void> listenToLive() async {
    final QueryBuilder<TimeAttendancesParseObject> query =
        QueryBuilder<TimeAttendancesParseObject>(TimeAttendancesParseObject());
    subscription = await liveQuery.client.subscribe(query);

    subscription?.on(LiveQueryEvent.update, (ParseObject value) {
      final String offsetStatus =
          value.get<String>(TimeAttendancesParseObject.keyOffsetStatus) ?? '';

      late final NotificationStatus status;
      late final String notificationText;

      switch (offsetStatus) {
        case pending:
          status = NotificationStatus.success;
          notificationText =
              'Successfully submitted offset request. You’ll be notified once approved.';
          break;
        case approved:
          status = NotificationStatus.success;
          notificationText = 'Your offset request has been approved.';
          break;
        case denied:
          status = NotificationStatus.error;
          notificationText = 'Your offset request has been denied.';
          break;
        default:
          return;
      }
      setState(
        () => notificationDialog = Align(
          child: notification(
            context: context,
            text: notificationText,
            status: status,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    listenToLive();
    context.read<TimeRecordCubit>().fetchAttendance();
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) {
      liveQuery.client.unSubscribe(subscription!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: kIsWeb && width > smWebMinWidth
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: height * 0.03),
                      child: Text(
                        'Daily Time Record',
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      spacing: width * 0.10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        const DTRClock(),
                        Column(
                          children: const <Widget>[
                            DTRDetails(),
                            OffsetButton(),
                            TimeInSlider()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (notificationDialog != null) notificationDialog!
          ],
        ),
      ),
    );
  }
}
