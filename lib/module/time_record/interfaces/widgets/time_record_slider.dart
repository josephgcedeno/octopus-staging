import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class TimeInSlider extends StatefulWidget {
  const TimeInSlider({
    required this.onSlide,
    required this.timeInEpoch,
    Key? key,
  }) : super(key: key);

  final Future<bool> Function(DismissDirection) onSlide;
  final int timeInEpoch;

  @override
  State<TimeInSlider> createState() => _TimeInSliderState();
}

class _TimeInSliderState extends State<TimeInSlider> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: kIsWeb ? 370 : width * 0.8,
      height: height * 0.07,
      margin: kIsWeb
          ? EdgeInsets.only(top: height * 0.08)
          : EdgeInsets.only(top: height * 0.02),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Colors.white,
            Color(0xFFe3f0ff),
            Color(0xFFd4e9ff),
          ],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.primaryColor.withAlpha(30),
            blurRadius: 30,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Align(
              child: Text(
                widget.timeInEpoch == -1 ? 'IN' : 'OUT',
                style: theme.textTheme.subtitle1?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Dismissible(
            direction: DismissDirection.startToEnd,
            confirmDismiss: widget.onSlide,
            key: UniqueKey(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: height * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: const Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
