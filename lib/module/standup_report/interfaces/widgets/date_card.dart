import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/standup_report/service/cubit/dsr_cubit.dart';

class DateCard extends StatelessWidget {
  const DateCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: theme.primaryColor.withOpacity(0.1),
      ),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: BlocBuilder<DSRCubit, DSRState>(
        buildWhen: (DSRState previous, DSRState current) =>
            current is FetchDatesSuccess || current is FetchDatesLoading,
        builder: (BuildContext context, DSRState state) {
          if (state is FetchDatesSuccess) {
            return FadeIn(
              duration: fadeInDuration,
              child: Text(
                state.dateString,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          return SizedBox(
            width: width * 0.5,
            child: lineLoader(height: 10, width: double.infinity),
          );
        },
      ),
    );
  }
}
