import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DailyAccomplishmentTextField extends StatefulWidget {
  const DailyAccomplishmentTextField({required this.name, Key? key})
      : super(key: key);

  final void Function(String) name;

  @override
  State<DailyAccomplishmentTextField> createState() =>
      _DailyAccomplishmentTextFieldState();
}

class _DailyAccomplishmentTextFieldState
    extends State<DailyAccomplishmentTextField> {
  final TextEditingController textController = TextEditingController();

  // For delay on change
  Timer? _debounce;

  // On change top text field (source wallet) will be handled by this function.
  void _onChangeTopTextField(String input) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    } // New changes will cancel the previous request

    if (input.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 1500), () {
        print('puasok');
        widget.name(input);
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.03,
      width: kIsWeb ? width * 0.15 : width * 0.3,
      margin: EdgeInsets.only(bottom: height * 0.01),
      child: TextField(
        controller: textController,
        onChanged: _onChangeTopTextField,
        style: TextStyle(
          color: theme.primaryColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          focusColor: theme.primaryColor,
          contentPadding: kIsWeb
              ? const EdgeInsets.only(bottom: 5, top: 3)
              : EdgeInsets.symmetric(
                  vertical: height * 0.006,
                ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          hintText: 'Name',
        ),
      ),
    );
  }
}
