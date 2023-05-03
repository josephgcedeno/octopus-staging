import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/interfaces/screens/splash_screen.dart';
import 'package:octopus/test/main_test.dart';

void main() {
  Future<void> pumpWidget(WidgetTester tester) async => tester.pumpWidget(
        universalPumper(
          const SplashScreen(),
        ),
      );

  group('Splash Screen', () {
    group('UI Components', () {
      testWidgets('Logo should apear', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(find.byType(SvgPicture), findsOneWidget);
      });
      testWidgets('Logo should be centered', (WidgetTester tester) async {
        await pumpWidget(tester);
        await tester.pump();
        expect(
          find.ancestor(
              of: find.byType(SvgPicture), matching: find.byType(Center),),
          findsOneWidget,
        );
      });
    });
  });
}
