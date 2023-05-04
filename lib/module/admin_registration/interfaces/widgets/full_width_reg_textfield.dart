import 'package:flutter/material.dart';

enum Type {
  normal,
  date,
}

class FullWidthTextField extends StatelessWidget {
  const FullWidthTextField({
    required this.textEditingController,
    required this.hint,
    required this.type,
    required this.tapFunction,
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hint;
  final Type type;
  final void Function() tapFunction;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      margin: EdgeInsets.only(top: height * 0.02),
      child: TextFormField(
        onTap: tapFunction,
        controller: textEditingController,
        readOnly: type == Type.date,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Fields cannot be empty.';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          filled: true,
        ),
      ),
    );
  }
}
