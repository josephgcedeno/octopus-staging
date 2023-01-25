import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class OffsetButton extends StatelessWidget {
  const OffsetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () {},
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
  }
}
