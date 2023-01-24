import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildDefaultTheme();
const Color kBlue = Color(0xFF017BFF);

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryColor: kBlue,
    colorScheme: base.colorScheme.copyWith(
      secondary: Colors.orange,
    ),
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith(
    headline6: base.headline6?.copyWith(fontFamily: 'Gilroy'),
    headline5: base.headline5?.copyWith(fontFamily: 'Gilroy'),
    headline4: base.headline4?.copyWith(fontFamily: 'Gilroy'),
    headline3: base.headline3?.copyWith(fontFamily: 'Gilroy'),
    headline2: base.headline2?.copyWith(fontFamily: 'Gilroy'),
    headline1: base.headline1?.copyWith(fontFamily: 'Gilroy'),
    subtitle2: base.subtitle2?.copyWith(fontFamily: 'Gilroy'),
    subtitle1: base.subtitle1?.copyWith(fontFamily: 'Gilroy'),
    bodyText2: base.bodyText2?.copyWith(fontFamily: 'Gilroy'),
    bodyText1: base.bodyText1?.copyWith(fontFamily: 'Gilroy'),
    caption: base.caption?.copyWith(fontFamily: 'Gilroy'),
    button: base.button?.copyWith(fontFamily: 'Gilroy'),
    overline: base.overline?.copyWith(fontFamily: 'Gilroy'),
  );
}

const Color shimmerBase = Colors.white38;
const Color shimmerGlow = Colors.white60;
