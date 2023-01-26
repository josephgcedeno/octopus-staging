import 'package:flutter/material.dart';

class MiniTextField extends StatelessWidget {
  const MiniTextField({required this.onTap, Key? key}) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      decoration: InputDecoration(
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: RotatedBox(
                quarterTurns: -1,
                child: Icon(
                  Icons.view_stream_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.padding_outlined,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: 'Enter task name',
        filled: true,
        fillColor: const Color(0xFFf5f7f9),
      ),
    );
  }
}
