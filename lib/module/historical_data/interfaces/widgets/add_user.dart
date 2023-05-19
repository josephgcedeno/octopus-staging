import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class AddUser extends StatelessWidget {
  const AddUser({required this.callback, Key? key}) : super(key: key);
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => callback.call(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 70,
            height: 30,
            padding:
                const EdgeInsets.only(left: 3, bottom: 2, top: 2, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: kBlue,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: kBlue,
                  ),
                ),
                Text(
                  'Add',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
