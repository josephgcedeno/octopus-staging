import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

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
    final double height = MediaQuery.of(context).size.height;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SizedBox(
      height: isClicked ? (isPortrait ? height * 0.11 : height * 0.20) : null,
      child: GestureDetector(
        onTap: () => setState(() {
          isClicked = !isClicked;
          widget.functionCall?.call();
        }),
        child: Container(
          padding: EdgeInsets.all(isPortrait ? width * 0.03 : height * 0.03),
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
          margin: isPortrait
              ? EdgeInsets.symmetric(
                  vertical: height * 0.017,
                  horizontal: width * 0.020,
                )
              : EdgeInsets.symmetric(
                  vertical: height * 0.01,
                  horizontal: width * 0.008,
                ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Icon(
                  widget.icon,
                  color: isClicked ? theme.primaryColor : kDarkGrey,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.018),
                  child: Text(
                    widget.title,
                    style: isClicked
                        ? theme.textTheme.displayMedium
                            ?.copyWith(color: theme.primaryColor)
                        : theme.textTheme.displayMedium?.copyWith(
                            color: kDarkGrey,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color:
                      isClicked ? theme.primaryColor : kDarkGrey.withOpacity(0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
