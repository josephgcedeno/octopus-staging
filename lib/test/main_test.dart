// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/debug_utils.dart';

Future<void> loadAllDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
}

Widget universalPumper(
  Widget child, {
  bool isUsedDefaultTheme = true,
  NavigatorObserver? observer,
  Object? arguements,
}) {
  return Builder(
    builder: (BuildContext context) {
      return MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        home: child,
        theme: isUsedDefaultTheme ? defaultTheme : null,
        navigatorObservers: observer != null
            ? <NavigatorObserver>[observer]
            : <NavigatorObserver>[],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute<dynamic>(
            settings: RouteSettings(
              arguments: arguements,
            ),
            builder: (_) => child,
          );
        },
      );
    },
  );
}
