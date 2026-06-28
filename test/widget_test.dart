// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:la_casona/core/routes/app_router.dart';
import 'package:la_casona/presentation/views/splash_view.dart';

void main() {
  testWidgets('La Casona opens splash and navigates to login', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRouter.splashPath,
      routes: [
        GoRoute(
          path: AppRouter.splashPath,
          name: AppRouter.splash,
          builder: (context, state) => const SplashView(),
        ),
        GoRoute(
          path: AppRouter.loginPath,
          name: AppRouter.login,
          builder: (context, state) =>
              const Scaffold(body: Text('Login listo')),
        ),
      ],
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    // Verify that the splash screen content is visible.
    expect(find.text('La Casona'), findsOneWidget);
    expect(find.text('Moda con alma colonial'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Login listo'), findsOneWidget);
  });
}
