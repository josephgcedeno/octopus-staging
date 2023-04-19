import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class AccomplishmentsDatePicker extends StatefulWidget {
  const AccomplishmentsDatePicker({
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  final void Function(DateTime) onDateSelected;

  @override
  State<AccomplishmentsDatePicker> createState() =>
      _AccomplishmentsDatePickerState();
}

class _AccomplishmentsDatePickerState extends State<AccomplishmentsDatePicker> {
  late DateTime _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(_selectedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: const Icon(
        Icons.event_note_outlined,
        color: kDarkGrey,
      ),
    );
  }
}
