import 'package:flutter/material.dart';

class FullWidthTextField extends StatelessWidget {
  const FullWidthTextField({
    required this.textEditingController,
    required this.hint,
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hint;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: textEditingController,
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
