import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

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
  bool isLoading = true;
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
          setState(() => isLoading = true);
        } else if (state is FetchTimeInDataSuccess) {
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
      child: Container(
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
              blurRadius: 40,
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
                        child: const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
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
      ),
    );
  }
}
