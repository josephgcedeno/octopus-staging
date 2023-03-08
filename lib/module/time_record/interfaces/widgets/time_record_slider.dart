import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already in for the day'),
          backgroundColor: Colors.green,
        ),
      );
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
            style: theme.textTheme.bodyText1
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 10),
          content: Text(
            'Are you done for today?',
            style: theme.textTheme.caption?.copyWith(
              color: const Color(0xff1B252F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.caption
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
                style: theme.textTheme.caption?.copyWith(
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
              timeInEpoch = state.attendance?.timeInEpoch ?? 0;
              requiredTimeInMinutes = state.attendance?.requiredDuration ?? 0;
              timeOutEpoch = state.attendance?.timeOutEpoch;

              /// If the timeout is not null, the position of the slider would be isIn.
              isIn = state.attendance?.timeOutEpoch != null;
            });
          }

          setState(() => isLoading = false);
        } else if (state is FetchTimeInDataFailed) {
          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.errorColor,
            ),
          );
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            width: kIsWeb ? 370 : width * 0.8,
            height: height * 0.07,
            margin: kIsWeb
                ? EdgeInsets.only(top: height * 0.08)
                : EdgeInsets.only(top: height * 0.02),
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
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    child: Text(
                      isIn ? 'IN' : 'OUT',
                      style: theme.textTheme.subtitle1?.copyWith(
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
                  key: UniqueKey(),
                  child: Align(
                    alignment:
                        isIn ? Alignment.centerLeft : Alignment.centerRight,
                    child: isLoading
                        ? Container(
                            height: height * 0.1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 9,
                            ),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: isIn ? theme.primaryColor : bgRed,
                              ),
                            ),
                          )
                        : Container(
                            height: height * 0.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isIn ? theme.primaryColor : bgRed,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isIn ? 17 : 10,
                            ),
                            child: Icon(
                              isIn
                                  ? Icons.keyboard_double_arrow_right_rounded
                                  : Icons.keyboard_double_arrow_left_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
