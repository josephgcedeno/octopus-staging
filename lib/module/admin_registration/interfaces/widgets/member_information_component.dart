import 'package:flutter/material.dart';

class InformationComponent extends StatelessWidget {
  const InformationComponent({
    required this.type,
    required this.value,
    Key? key,
  }) : super(key: key);
  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      width: width * 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: width * 0.3,
            child: Text(
              type,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.3,
            child: Text(
              value,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
