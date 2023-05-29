import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';

class HistoricalMenuButton extends StatefulWidget {
  const HistoricalMenuButton({
    required this.title,
    required this.icon,
    Key? key,
    this.functionCall,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback? functionCall;

  @override
  State<HistoricalMenuButton> createState() => _HrMenuButtonState();
}

class _HrMenuButtonState extends State<HistoricalMenuButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: kIsWeb && width > smWebMinWidth ? width * 0.30 : width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onTap: () => setState(() {
              isClicked = !isClicked;
              widget.functionCall?.call();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18.5,
              ),
              margin: kIsWeb && width > smWebMinWidth
                  ? const EdgeInsets.only(right: 25)
                  : const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: isClicked
                    ? <BoxShadow>[
                        BoxShadow(
                          color: kBlue.withOpacity(0.17),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Icon(
                          widget.icon,
                          color: isClicked ? theme.primaryColor : kDarkGrey,
                        ),
                      ),
                      Text(
                        widget.title,
                        style: isClicked
                            ? theme.textTheme.displayMedium
                                ?.copyWith(color: theme.primaryColor)
                            : theme.textTheme.displayMedium?.copyWith(
                                color: kDarkGrey,
                              ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: isClicked
                        ? theme.primaryColor
                        : kDarkGrey.withOpacity(0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
