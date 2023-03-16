import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/time_record/interfaces/screens/request_offset_screen.dart';
import 'package:octopus/module/time_record/service/cubit/time_record_cubit.dart';

class OffsetButton extends StatelessWidget {
  const OffsetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<TimeRecordCubit, TimeRecordState>(
      builder: (BuildContext context, TimeRecordState state) {
        if (state is FetchTimeInDataLoading) {
          return lineLoader(
            height: 35,
            width: kIsWeb ? 370 / 2 : width * 0.40,
            borderRadius: BorderRadius.circular(10),
          );
        }
        return ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (_) => const RequestOffsetScreen(),
              ),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFFE5F2FF)),
            elevation: MaterialStateProperty.all(0),
            padding: kIsWeb
                ? MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  )
                : MaterialStateProperty.all(const EdgeInsets.all(12)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Request for offset',
            style: kIsWeb
                ? theme.textTheme.bodyText2?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  )
                : theme.textTheme.caption?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        );
      },
    );
  }
}
