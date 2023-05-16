import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/interfaces/widgets/active_button_tab.dart';
import 'package:octopus/interfaces/widgets/date_and_time_picker.dart';

enum PickTypeSelected { today, custom }

class PickDate extends StatefulWidget {
  const PickDate({
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final void Function({
    required PickTypeSelected pickTypeSelected,
    DateTime? today,
    DateTime? from,
    DateTime? to,
  }) callBack;
  @override
  State<PickDate> createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  final TextEditingController textController = TextEditingController();

  final DateTime currentDate = DateTime.now();
  bool isToday = true;

  @override
  void initState() {
    super.initState();
    textController.text = DateFormat('yyyy/MM/dd').format(currentDate);

    /// By default trigger callback using today's date time, the "to" date will be set to null only the "from" date will be specified when type is today.
    widget.callBack.call(
      pickTypeSelected: PickTypeSelected.today,
      today: currentDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Pick a date'),
        Row(
          children: <Widget>[
            ActiveButtonTab(
              title: 'Today',
              onPressed: () => setState(() => isToday = true),
              isClicked: isToday,
            ),
            ActiveButtonTab(
              title: 'Custom',
              onPressed: () => setState(() => isToday = false),
              isClicked: !isToday,
            ),
          ],
        ),
        if (isToday)
          TextField(
            autofocus: true,
            readOnly: true,
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFf5f7f9),
            ),
          )
        else
          Container(
            margin: EdgeInsets.only(
              top: height * 0.01,
              bottom: height * 0.02,
            ),
            child: DateTimePicker<DateTime>(
              type: PickerType.date,
              isRestrictPreviousDay: false,
              showLabel: false,
              callBack: (DateTime from, DateTime to) {
                /// On successfully selected from & to date, trigger callback and return theses values.
                widget.callBack.call(
                  pickTypeSelected: PickTypeSelected.custom,
                  from: from,
                  to: to,
                );
              },
            ),
          ),
      ],
    );
  }
}
