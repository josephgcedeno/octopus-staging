import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/configs/themes.dart';

/// Splash screen, only shows for a few milliseconds. fades out to authentication_screen afterwards.

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              gradient1,
              gradient2,
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: height * 0.05),
            width: width * 0.35,
            height: height * 0.20,
            child: SvgPicture.asset(whiteLogoSvg),
          ),
        ),
      ),
    );
  }
}
