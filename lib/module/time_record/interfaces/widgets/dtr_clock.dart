import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DTRClock extends StatefulWidget {
  const DTRClock({required this.timeInEpoch, Key? key}) : super(key: key);

  final int timeInEpoch;

  @override
  State<DTRClock> createState() => _DTRClockState();
}

class _DTRClockState extends State<DTRClock> {
  static Duration oneSecondDuration = const Duration(seconds: 1);

  /// Standard 8 hours of work
  final int timeToRenderInMilliseconds = 28800000;

  bool ticked = false;
  Duration elapsed = Duration.zero;
  Timer timer = Timer(oneSecondDuration, () {});
  int remainingTimeEpoch = -1;
  double clockPercentage = 0.0;
  bool isOff = false;

  String formatTimer(Duration duration) {
    Duration value = duration;
    String format(Duration d) => d.toString().split('.').first.padLeft(8, '0');
    final int days = value.inHours ~/ 24;
    value -= Duration(hours: days * 24);
    return format(value);
  }

  Duration remainingTime() {
    final int outTimeEpoch = widget.timeInEpoch + timeToRenderInMilliseconds;
    final int currentEpoch = DateTime.now().millisecondsSinceEpoch;
    remainingTimeEpoch = outTimeEpoch - currentEpoch;
    return Duration(milliseconds: remainingTimeEpoch);
  }

  bool isOvertime() {
    return remainingTime() < const Duration(seconds: 1);
  }

  Color progressColor() {
    if (isOff) {
      return kBlue.withAlpha(30);
    } else if (!isOvertime()) {
      return kBlue;
    } else {
      return Colors.amber;
    }
  }

  String clockLabel() {
    if (isOff) {
      return 'Time In';
    } else if (isOvertime()) {
      return 'Overtime';
    } else {
      return 'Time remaining';
    }
  }

  void startTicker() {
    elapsed = Duration(milliseconds: remainingTimeEpoch.abs());
    timer = Timer.periodic(
      oneSecondDuration,
      (_) => setState(
        () => elapsed = oneSecondDuration +
            Duration(milliseconds: remainingTimeEpoch.abs()),
      ),
    );
  }

  void initializeClock() {
    if (widget.timeInEpoch == -1) {
      setState(() => isOff = true);
    } else {
      if (isOvertime()) {
        startTicker();
      }
      calculateClockPercentage();
      setState(() => isOff = false);
    }
  }

  void calculateClockPercentage() {
    final int remainingMilliseconds = remainingTime().inMilliseconds;
    double percent = 1.0 - (remainingMilliseconds / timeToRenderInMilliseconds);
    if (percent > 1) {
      percent = 1;
    }
    setState(() {
      clockPercentage = percent;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeClock();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final TextStyle? timerTextStyle = kIsWeb
        ? theme.textTheme.headline3?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          )
        : theme.textTheme.headline4?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          );

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.primaryColor.withAlpha(30),
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width),
        child: CircularPercentIndicator(
          fillColor: Colors.white,
          radius: height * 0.15,
          lineWidth: 15.0,
          percent: clockPercentage,
          reverse: true,
          center: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isOff)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('0:00:00', style: timerTextStyle),
                    ],
                  )
                else if (isOvertime())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('+', style: theme.textTheme.headline5),
                      Text(
                        formatTimer(elapsed),
                        style: timerTextStyle,
                      ),
                    ],
                  )
                else
                  TweenAnimationBuilder<Duration>(
                    duration: remainingTime(),
                    tween: Tween<Duration>(
                      begin: remainingTime(),
                      end: Duration.zero,
                    ),
                    builder: (
                      BuildContext context,
                      Duration value,
                      Widget? child,
                    ) {
                      if (isOvertime()) {
                        startTicker();
                      }
                      return Text(
                        formatTimer(value),
                        style: timerTextStyle,
                      );
                    },
                  ),
                Text(
                  clockLabel(),
                  style: kIsWeb
                      ? theme.textTheme.subtitle1
                      : theme.textTheme.caption,
                )
              ],
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: theme.primaryColor.withAlpha(15),
          progressColor: progressColor(),
        ),
      ),
    );
  }
}
