import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abc_kids_game/screens/onboarding_screen.dart';
import 'package:abc_kids_game/screens/home_screen.dart';
import 'package:abc_kids_game/constants/app_constants.dart';

void main() {
  // ── Onboarding Screen ───────────────────────────────────────
  group('OnboardingScreen', () {
    testWidgets('renders app name and Tap to Start button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.textContaining('Tap to Start'), findsOneWidget);
    });

    testWidgets('navigates to HomeScreen on button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Tap to Start'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  // ── Home Screen ─────────────────────────────────────────────
  group('HomeScreen', () {
    testWidgets('renders all 3 mode cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.learnMode), findsOneWidget);
      expect(find.text(AppStrings.playMode),  findsOneWidget);
      expect(find.text(AppStrings.traceMode), findsOneWidget);
    });
  });
}
