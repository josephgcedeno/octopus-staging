import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildDefaultTheme();
const Color kBlue = Color(0xFF017BFF);
const Color kRed = Color(0xFFE63462);
const Color kBlack = Color(0xFF000000);

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _buildDefaultTextTheme(base.textTheme),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: kBlue,
    colorScheme: base.colorScheme.copyWith(
      secondary: Colors.orange,
      error: kRed,
    ),
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith(
    titleLarge: base.titleLarge?.copyWith(
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w900,
    ),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: 'Gilroy'),
    headlineMedium: base.headlineMedium?.copyWith(fontFamily: 'Gilroy'),
    displaySmall: base.displaySmall?.copyWith(fontFamily: 'Gilroy'),
    displayMedium: base.displayMedium?.copyWith(fontFamily: 'Gilroy'),
    displayLarge: base.displayLarge?.copyWith(
      fontFamily: 'Gilroy',
      fontSize: 34,
      height: 1.5,
      color: kBlack,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: base.titleSmall?.copyWith(fontFamily: 'Gilroy'),
    titleMedium: base.titleMedium?.copyWith(fontFamily: 'Gilroy'),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: 'Gilroy'),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: 'Gilroy'),
    bodySmall: base.bodySmall?.copyWith(fontFamily: 'Gilroy'),
    labelLarge: base.labelLarge?.copyWith(fontFamily: 'Gilroy'),
    labelSmall: base.labelSmall?.copyWith(fontFamily: 'Gilroy'),
  );
}

const Color shimmerBase = Colors.white38;
const Color shimmerGlow = Colors.white60;
const Color gradient1 = Color(0xFF57A6FC);
const Color gradient2 = Color(0xFF017BFF);

const String logoSvg = 'assets/images/app_logo.svg';
const String whiteLogoSvg = 'assets/images/app_logo_white.svg';
const String logoPng = 'assets/images/app_logo.png';
