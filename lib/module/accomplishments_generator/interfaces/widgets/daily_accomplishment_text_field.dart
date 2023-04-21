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

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      setState(() {
        widget.name(textController.text);
      });
    });
  }

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
      width: width * 0.3,
      margin: EdgeInsets.only(bottom: height * 0.01),
      child: TextField(
        controller: textController,
        style: TextStyle(
          color: theme.primaryColor,
        ),
        decoration: InputDecoration(
          focusColor: theme.primaryColor,
          contentPadding: EdgeInsets.symmetric(
            vertical: height * 0.009,
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
