import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class TimeInSlider extends StatefulWidget {
  const TimeInSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeInSlider> createState() => _TimeInSliderState();
}

class _TimeInSliderState extends State<TimeInSlider> {
  Future<bool> timeInTimeOut(DismissDirection dir) async {
    if (timeOutEpoch != null) {
      showSnackBar(message: 'You have already ended work for the day.');
      return false;
    }

    /// This condition will check to drag is TIME IN
    if (isIn) {
      context.read<TimeRecordCubit>().signInToday();
    } else {
      showAlertDialogOnTimeOut(context);
    }
    return false;
  }

  void showAlertDialogOnTimeOut(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xffA8A8A8).withOpacity(0.40),
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);

        return AlertDialog(
          alignment: const Alignment(0.0, -0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Time Out',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 10),
          content: Text(
            'Are you done for today?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xff1B252F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff1B252F)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                /// This condition will check to drag is TIME OUT
                context.read<TimeRecordCubit>().signOutToday();
              },
              child: Text(
                'Confirm',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Set what time did the user time in.
  int timeInEpoch = -1;

  /// Set what is the required time for the user to render. Default is 8hr in Minute is 480.
  int requiredTimeInMinutes = 480;

  /// Set what time to did the user time out.
  int? timeOutEpoch;

  bool isLoading = true;

  /// Check if it is IN or OUT
  bool isIn = true;

  final Color bgRed = const Color(0xffE25252);

  /// Time out gradient color
  final LinearGradient outLinearGradient = const LinearGradient(
    colors: <Color>[
      Colors.white,
      Color(0xFFFFECEC),
      Color(0xFFF88484),
    ],
  );

  /// Time in gradient color
  final LinearGradient inLinearGradient = const LinearGradient(
    colors: <Color>[
      Colors.white,
      Color(0xFFe3f0ff),
      Color(0xFFd4e9ff),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<TimeRecordCubit, TimeRecordState>(
      listenWhen: (TimeRecordState previous, TimeRecordState current) =>
          current is FetchTimeInDataLoading ||
          current is FetchTimeInDataSuccess ||
          current is FetchTimeInDataFailed,
      listener: (BuildContext context, TimeRecordState state) {
        if (state is FetchTimeInDataLoading) {
          setState(() {
            /// This will indicate which position does the loader will be executed, either isIn or isOut.
            isIn = timeInEpoch == -1;

            isLoading = true;
            timeInEpoch = -1;
            timeOutEpoch = null;
          });
        } else if (state is FetchTimeInDataSuccess) {
          if (state.attendance != null) {
            setState(() {
              timeInEpoch = state.attendance?.timeInEpoch ?? -1;
              requiredTimeInMinutes =
                  state.attendance?.requiredDuration ?? requiredTimeInMinutes;
              timeOutEpoch = state.attendance?.timeOutEpoch;

              /// If the timeout is not null, the position of the slider would be isIn.
              isIn = state.attendance?.timeInEpoch == null ||
                  state.attendance?.timeOutEpoch != null;
            });
          }

          setState(() => isLoading = false);
        } else if (state is FetchTimeInDataFailed &&
            state.origin == ExecutedOrigin.fetchAttendance) {
          setState(() => isLoading = false);

          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: isLoading
          ? Container(
              margin: kIsWeb
                  ? EdgeInsets.only(top: height * 0.08)
                  : EdgeInsets.only(top: height * 0.02),
              child: lineLoader(
                height: height >= smMinHeight && height <= smMaxHeight
                    ? height * 0.07
                    : 61.01,
                width: kIsWeb ? 370 : width * 0.8,
                borderRadius: BorderRadius.circular(50),
              ),
            )
          : Column(
              children: <Widget>[
                Container(
                  width: kIsWeb ? 370 : width * 0.8,
                  height: height >= smMinHeight && height <= smMaxHeight
                      ? height * 0.07
                      : 61.01,
                  margin: kIsWeb
                      ? EdgeInsets.only(top: height * 0.08)
                      : EdgeInsets.only(top: height * 0.02),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: isIn ? inLinearGradient : outLinearGradient,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: isIn
                            ? theme.primaryColor.withAlpha(30)
                            : bgRed.withAlpha(30),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraint) {
                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Align(
                              child: Text(
                                isIn ? 'IN' : 'OUT',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isIn ? theme.primaryColor : bgRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Dismissible(
                            direction: isIn
                                ? DismissDirection.startToEnd
                                : DismissDirection.endToStart,
                            confirmDismiss: timeInTimeOut,
                            dragStartBehavior: DragStartBehavior.down,
                            key: UniqueKey(),
                            child: Align(
                              alignment: isIn
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                width: constraint.maxHeight,
                                height: constraint.maxHeight,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isIn ? theme.primaryColor : bgRed,
                                ),
                                child: Icon(
                                  isIn
                                      ? Icons
                                          .keyboard_double_arrow_right_rounded
                                      : Icons
                                          .keyboard_double_arrow_left_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
