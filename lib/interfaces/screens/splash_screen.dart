import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/configs/themes.dart';
import '../widgets/gradient_bg.dart';

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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GradientBG(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.05),
          width: width * 0.35,
          height: height * 0.20,
          child: SvgPicture.asset(whiteLogoSvg),
        ),
      ),
    );
  }
}
