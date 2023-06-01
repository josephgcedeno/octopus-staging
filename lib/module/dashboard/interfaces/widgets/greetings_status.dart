import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/service/cubit/secure_storage_cubit_cubit.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/local_storage.dart';

class GreetingsStatus extends StatefulWidget {
  const GreetingsStatus({Key? key}) : super(key: key);

  @override
  State<GreetingsStatus> createState() => _GreetingsStatusState();
}

class _GreetingsStatusState extends State<GreetingsStatus> {
  String greetingsText() {
    final DateTime currentTime = DateTime.now();
    final int currentHour = currentTime.hour;

    String greetingText;

    if (currentHour >= 0 && currentHour < 12) {
      greetingText = 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 16) {
      greetingText = 'Good Afternoon';
    } else if (currentHour >= 16 && currentHour < 20) {
      greetingText = 'Good Evening';
    } else {
      greetingText = 'Good Night';
    }
    return greetingText;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: context.read<SecureStorageCubit>().read(key: lsFirstName),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        final ThemeData theme = Theme.of(context);

        if (snapshot.hasData && snapshot.data != null && snapshot.data != '') {
          return RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${greetingsText()}!\n',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: snapshot.data,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        return lineLoader(
          height: 20,
          width: 50,
        );
      },
    );
  }
}
