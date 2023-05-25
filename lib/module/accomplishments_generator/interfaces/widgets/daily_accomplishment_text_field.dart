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

  // On change top text field (source wallet) will be handled by this function.
  void _onChangeTopTextField(String input) => widget.name(input);

  @override
  void dispose() {
    textController.dispose();
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
          fontSize: height * 0.030,
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
