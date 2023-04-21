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
      height: height * 0.006,
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
