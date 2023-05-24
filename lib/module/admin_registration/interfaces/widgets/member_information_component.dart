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
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrain) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                type,
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: constrain.maxWidth * 0.60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
