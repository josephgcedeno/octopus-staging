import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class RequestOffsetScreen extends StatefulWidget {
  const RequestOffsetScreen({Key? key}) : super(key: key);

  @override
  State<RequestOffsetScreen> createState() => _RequestOffsetScreenState();
}

class _RequestOffsetScreenState extends State<RequestOffsetScreen> {
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();
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

  TimeOfDay initialTime(int index) {
    if (index == 0 && fromTextController.text.isNotEmpty) {
      return fromTime;
    } else if (index == 1 && toTextController.text.isNotEmpty) {
      return toTime;
    } else {
      return TimeOfDay.now();
    }
  }

  Future<void> openTimePicker({
    required BuildContext context,
    required int index,
  }) async {
    final TimeOfDay? res = await showTimePicker(
      context: context,
      initialTime: initialTime(index),
    );
    if (res == null || !mounted) return;

    final String timeFormat = res.format(context);

    if (index == 0) {
      fromTextController.text = timeFormat;
      fromTime = res;
    } else {
      toTextController.text = timeFormat;
      toTime = res;
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            offsetDurationInHours < 0
                ? 'The time offset ($offsetDurationInHours) should not be less than 0!'
                : offsetDuration.inMinutes == 0
                    ? 'Request offset should not be 0.'
                    : '$maximumTimeText.',
          ),
          backgroundColor: kRed,
        ),
      );
      return;
    }

    context.read<TimeRecordCubit>().requestOffset(
          offsetDuration: offsetDuration,
          fromTime: fromTextController.text,
          toTime: toTextController.text,
          reason: reasonTextController.text,
        );
    return;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

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
          child: SingleChildScrollView(
            child: Container(
              height: height * 0.87,
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
                            style: kIsWeb
                                ? theme.textTheme.headline6
                                : theme.textTheme.subtitle1?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                        Text(
                          'I’ll be away the next working day...',
                          style: theme.textTheme.bodyText1,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                            bottom: 13,
                          ),
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (
                              BuildContext context,
                              BoxConstraints constraints,
                            ) {
                              return Row(
                                children: <Widget>[
                                  for (int i = 0; i < 2; i++)
                                    Container(
                                      margin: i == 0
                                          ? EdgeInsets.only(
                                              right:
                                                  constraints.maxWidth * 0.05,
                                            )
                                          : null,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 5.0,
                                              left: 3.0,
                                            ),
                                            child: Text(
                                              i == 0 ? 'From' : 'To',
                                              style: kIsWeb
                                                  ? theme.textTheme.headline6
                                                  : theme.textTheme.subtitle1
                                                      ?.copyWith(
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.45,
                                            child: TextFormField(
                                              onTap: () => openTimePicker(
                                                context: context,
                                                index: i,
                                              ),
                                              controller: i == 0
                                                  ? fromTextController
                                                  : toTextController,
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Fields cannot be empty.';
                                                }
                                                return null;
                                              },
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintText: i == 0
                                                    ? 'Eg. 3:20 PM'
                                                    : 'Eg. 4:20 PM',
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(
                                Icons.info,
                                color: blackColor,
                                size: 15,
                              ),
                            ),
                            Text(
                              maximumTimeText,
                              style: theme.textTheme.caption?.copyWith(
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
                              hintStyle: theme.textTheme.caption,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.03),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
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
                                style: theme.textTheme.bodyText1?.copyWith(
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
        ),
      ),
    );
  }
}
