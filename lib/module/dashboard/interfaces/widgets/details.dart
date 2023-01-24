import 'package:flutter/material.dart';

class DTRDetails extends StatelessWidget {
  const DTRDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    final List<String> labels = <String>[
      'Date today:',
      'Time In:',
      'Time Out:',
      'Overtime:',
      'Time to render:'
    ];
    final List<String> values = <String>[
      'January 18, 2023',
      '8:30 AM',
      '-----',
      '-----',
      '8 hours'
    ];

    return Container(
      padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.03),
      width: 350,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    labels[i],
                    style:
                        theme.textTheme.bodyText2?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    values[i],
                    style: theme.textTheme.subtitle1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
