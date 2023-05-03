import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class AccomplishmentsDatePicker extends StatefulWidget {
  const AccomplishmentsDatePicker({
    required this.onDateSelected,
    required this.shouldProjectDateChange,
    this.isClicked = false,
    Key? key,
  }) : super(key: key);

  final void Function(DateTime) onDateSelected;
  final bool isClicked;
  final bool shouldProjectDateChange;

  @override
  State<AccomplishmentsDatePicker> createState() =>
      _AccomplishmentsDatePickerState();
}

class _AccomplishmentsDatePickerState extends State<AccomplishmentsDatePicker> {
  late DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    if (widget.shouldProjectDateChange) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
        widget.onDateSelected(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Icon(
        Icons.event_note_outlined,
        color: widget.isClicked ? theme.primaryColor : kDarkGrey,
      ),
    );
  }
}
