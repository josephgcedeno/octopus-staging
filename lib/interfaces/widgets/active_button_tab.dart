import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class ActiveButtonTab extends StatelessWidget {
  const ActiveButtonTab({
    required this.isClicked,
    required this.title,
    required this.onPressed,
    this.isWeb = false,
    Key? key,
  }) : super(key: key);

  final bool isClicked;
  final String title;
  final VoidCallback onPressed;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return InkWell(
      splashColor: ktransparent,
      highlightColor: ktransparent,
      onTap: onPressed,
      child: Container(
        padding: isWeb
            ? const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 34,
              )
            : EdgeInsets.symmetric(
                vertical: width * 0.02,
                horizontal: width * 0.05,
              ),
        margin: isWeb
            ? null
            : EdgeInsets.only(
                top: width * 0.02,
                bottom: width * 0.02,
                right: width * 0.03,
              ),
        decoration: isWeb
            ? BoxDecoration(
                color: isClicked
                    ? theme.primaryColor.withOpacity(0.10)
                    : kLightGrey,
                border: isClicked
                    ? Border(
                        bottom: BorderSide(
                          color: theme.primaryColor,
                          width: 2.0,
                        ),
                      )
                    : null,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isClicked
                    ? theme.primaryColor.withOpacity(0.10)
                    : kLightGrey,
              ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: isClicked ? theme.primaryColor : kLightBlack),
        ),
      ),
    );
  }
}
