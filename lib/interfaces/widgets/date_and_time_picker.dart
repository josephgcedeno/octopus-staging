import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PickerType {
  date,
  time,
}

class DateTimePicker<T> extends StatefulWidget {
  const DateTimePicker({
    required this.type,
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final PickerType type;
  final void Function(T from, T to) callBack;

  @override
  State<DateTimePicker<T>> createState() => _DateTimePickerState<T>();
}

final Color blackColor = const Color(0xff1B252F).withOpacity(70 / 100);

class _DateTimePickerState<T> extends State<DateTimePicker<T>> {
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();

  late T fromTime;
  late T toTime;

  late T fromDate;
  late T toDate;

  T initialTime(int index) {
    if (index == 0 && fromTextController.text.isNotEmpty) {
      return fromTime;
    } else if (index == 1 && toTextController.text.isNotEmpty) {
      return toTime;
    } else {
      return TimeOfDay.now() as T;
    }
  }

  Future<void> openDatePicker({
    required BuildContext context,
    required int index,
  }) async {
    final DateTime? res = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (res == null || !mounted) return;

    final String dateFormat = DateFormat('MM/dd/yy').format(res);

    if (index == 0) {
      fromTextController.text = dateFormat;
      fromDate = res as T;
    } else {
      toTextController.text = dateFormat;
      toDate = res as T;
    }

    /// Trigger callback if both fields are filled.
    if (fromTextController.text.isNotEmpty &&
        toTextController.text.isNotEmpty) {
      widget.callBack.call(fromDate, toDate);
    }
  }

  Future<void> openTimePicker({
    required BuildContext context,
    required int index,
  }) async {
    final TimeOfDay? res = await showTimePicker(
      context: context,
      initialTime: initialTime(index) as TimeOfDay,
    );
    if (res == null || !mounted) return;

    final String timeFormat = res.format(context);

    if (index == 0) {
      fromTextController.text = timeFormat;
      fromTime = res as T;
    } else {
      toTextController.text = timeFormat;
      toTime = res as T;
    }

    /// Trigger callback if both fields are filled.
    if (fromTextController.text.isNotEmpty &&
        toTextController.text.isNotEmpty) {
      widget.callBack.call(fromTime, toTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
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
                        right: constraints.maxWidth * 0.05,
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        left: 3.0,
                      ),
                      child: Text(
                        i == 0 ? 'From' : 'To',
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium?.copyWith(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.45,
                      child: TextFormField(
                        onTap: () => widget.type != PickerType.time
                            ? openDatePicker(
                                context: context,
                                index: i,
                              )
                            : openTimePicker(context: context, index: i),
                        controller:
                            i == 0 ? fromTextController : toTextController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Fields cannot be empty.';
                          }
                          return null;
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: widget.type == PickerType.date
                              ? const Icon(Icons.calendar_month_outlined)
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: () {
                            if (widget.type == PickerType.date) {
                              return 'mm/dd/yy';
                            } else {
                              return i == 0 ? 'Eg. 3:20 PM' : 'Eg. 4:20 PM';
                            }
                          }(),
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
    );
  }
}
