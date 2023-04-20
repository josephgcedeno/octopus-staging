import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class DailyAccomplishmentBulletList extends StatelessWidget {
  const DailyAccomplishmentBulletList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: width,
          padding: EdgeInsets.only(bottom: width * 0.010),
          margin: EdgeInsets.only(bottom: width * 0.015),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: kDarkGrey.withOpacity(0.4),
              ),
            ),
          ),
          child: const Text(
            'Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: const Icon(
                    Icons.check,
                    color: kLightBlack,
                    size: 15,
                  ),
                ),
                const Text('First bullet'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
