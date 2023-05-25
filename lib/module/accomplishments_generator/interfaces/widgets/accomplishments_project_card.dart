import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccomplishmentsProjectCard extends StatelessWidget {
  const AccomplishmentsProjectCard({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    this.image,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(right: width * 0.02),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kIsWeb ? 8 : 20),
      ),
      child: kIsWeb && width > 1200
          ? Container(
              alignment: Alignment.center,
              width: width * 0.18,
              height: height * 0.13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: image,
                  ),
                  FittedBox(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.015),
                  width: width * 0.25,
                  height: height * 0.09,
                  child: image,
                ),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600, color: textColor),
                ),
              ],
            ),
    );
  }
}
