import 'dart:async';

import 'package:flutter/material.dart';

/// Splash screen, only shows for a few milliseconds. fades out to authentication_screen afterwards.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 1.0;

  Timer interval = Timer(const Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    interval = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    interval.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.05),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(milliseconds: 500),
                  child: const Icon(
                    Icons.blur_on_outlined,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  'Development',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
