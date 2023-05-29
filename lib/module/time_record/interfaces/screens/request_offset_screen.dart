import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/date_and_time_picker.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class RequestOffsetScreen extends StatefulWidget {
  const RequestOffsetScreen({Key? key}) : super(key: key);

  @override
  State<RequestOffsetScreen> createState() => _RequestOffsetScreenState();
}

class _RequestOffsetScreenState extends State<RequestOffsetScreen> {
  final TextEditingController reasonTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color blackColor = const Color(0xff1B252F).withOpacity(70 / 100);

  final DateTime now = DateTime.now();

  /// Store the unformatted values of the selected time.
  late TimeOfDay fromTime;
  late TimeOfDay toTime;

  final int maximumOffset = 4;
  final String maximumTimeText = 'Maximum time to offset is 4 hours';

  bool isLoading = false;

  Future<void> saveOffset() async {
    final DateTime fromDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      fromTime.hour,
      fromTime.minute,
    );
    final DateTime toDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      toTime.hour,
      toTime.minute,
    );

    final Duration offsetDuration = toDateTime.difference(fromDateTime);
    final int offsetDurationInHours = offsetDuration.inHours;

    if (offsetDurationInHours > maximumOffset ||
        offsetDurationInHours < 0 ||
        offsetDuration.inMinutes == 0) {
      showSnackBar(
        message: offsetDurationInHours < 0
            ? 'The time offset ($offsetDurationInHours) should not be less than 0!'
            : offsetDuration.inMinutes == 0
                ? 'Request offset should not be 0.'
                : '$maximumTimeText.',
        snackBartState: SnackBartState.error,
      );
      return;
    }

    context.read<TimeRecordCubit>().requestOffset(
          offsetDuration: offsetDuration,
          fromTime: fromTime.format(context),
          toTime: toTime.format(context),
          reason: reasonTextController.text,
        );
    return;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: BlocListener<TimeRecordCubit, TimeRecordState>(
        listenWhen: (TimeRecordState previous, TimeRecordState current) =>
            current is FetchTimeInDataLoading ||
            current is FetchTimeInDataSuccess ||
            current is FetchTimeInDataFailed,
        listener: (BuildContext context, TimeRecordState state) {
          if (state is FetchTimeInDataLoading) {
            setState(() => isLoading = true);
            return;
          } else if (state is FetchTimeInDataSuccess) {
            setState(() => isLoading = false);
            if (state.attendance != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Successfully requested offset.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              Future<void>.delayed(
                const Duration(milliseconds: 500),
                () => Navigator.of(context).pop(),
              );
              return;
            }
          } else if (state is FetchTimeInDataFailed &&
              state.origin == ExecutedOrigin.requestOffset) {
            setState(() => isLoading = false);

            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ),
                    backgroundColor: kRed,
                  ),
                )
                .closed
                .then((_) => ScaffoldMessenger.of(context).clearSnackBars());
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: height * 0.03, top: 20),
                        child: Text(
                          'Request Offset',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'I’ll be away the next working day...',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      child: SizedBox(
                        width: kIsWeb && width > smWebMinWidth
                            ? width * 0.45
                            : width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 13,
                                  ),
                                  width: double.infinity,
                                  child: DateTimePicker<TimeOfDay>(
                                    type: PickerType.time,
                                    callBack: (TimeOfDay from, TimeOfDay to) {
                                      fromTime = from;
                                      toTime = to;
                                    },
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.info,
                                        color: blackColor,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      maximumTimeText,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextFormField(
                                    controller: reasonTextController,
                                    maxLines: 8,
                                    minLines: 8,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Fields cannot be empty.';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText:
                                          'Write reason (e.g. Process personal documents)',
                                      hintStyle: theme.textTheme.bodySmall,
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: kIsWeb && width > smWebMinWidth
                                  ? width * 0.45
                                  : width,
                              margin: EdgeInsets.only(bottom: height * 0.03),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: theme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: kIsWeb ? 23 : 10,
                                    horizontal: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          saveOffset();
                                        }
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'Request',
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
