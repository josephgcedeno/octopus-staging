import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/reminders/reminders_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/service/cubit/reminder_cubit.dart';

class PanelReminder extends StatefulWidget {
  const PanelReminder({Key? key}) : super(key: key);

  @override
  State<PanelReminder> createState() => _PanelReminderState();
}

class _PanelReminderState extends State<PanelReminder> {
  @override
  void initState() {
    super.initState();
    context.read<ReminderCubit>().fetchReminderToday();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<ReminderCubit, ReminderState>(
      listenWhen: (ReminderState previous, ReminderState current) =>
          current is FetchReminderTodayFailed,
      listener: (BuildContext context, ReminderState state) {
        if (state is FetchReminderTodayFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      buildWhen: (ReminderState previous, ReminderState current) =>
          current is FetchReminderTodayLoading ||
          current is FetchReminderTodaySuccess,
      builder: (BuildContext context, ReminderState state) {
        if (state is FetchReminderTodaySuccess) {
          if (state.reminders.isEmpty) {
            return DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              color: const Color(0x421B252F),
              child: Container(
                padding: const EdgeInsets.all(8),
                width: width,
                child: SvgPicture.asset(nuxifyTakingNotesSvg),
              ),
            );
          }
          return Column(
            children: <Widget>[
              for (final Reminder reminder in state.reminders)
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.015,
                    horizontal: 15,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color(0xFF4BA1FF),
                        Color(0xFF017BFF),
                      ],
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        reminder.announcement,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
        return Column(
          children: <Widget>[
            for (int i = 0; i < 2; i++)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: lineLoader(height: height * 0.055, width: width),
                ),
              )
          ],
        );
      },
    );
  }
}
