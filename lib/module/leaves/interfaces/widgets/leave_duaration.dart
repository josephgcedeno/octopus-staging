import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LeaveDuration extends StatefulWidget {
  const LeaveDuration({Key? key}) : super(key: key);

  @override
  State<LeaveDuration> createState() => _LeaveDurationState();
}

final Color blackColor = const Color(0xff1B252F).withOpacity(70 / 100);

class _LeaveDurationState extends State<LeaveDuration> {
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return Row(
          children: <Widget>[
            for (int i = 0; i < 2; i++)
              Container(
                margin: i == 0
                    ? EdgeInsets.only(
                        right: constraints.maxWidth * 0.05,
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        left: 3.0,
                      ),
                      child: Text(
                        i == 0 ? 'From' : 'To',
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium?.copyWith(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.45,
                      child: TextFormField(
                        controller:
                            i == 0 ? fromTextController : toTextController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'mm/dd/yy',
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
