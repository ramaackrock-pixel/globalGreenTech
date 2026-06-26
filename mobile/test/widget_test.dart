import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_green_tech/main.dart';
import 'package:global_green_tech/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  testWidgets('App loads unified login page by default', (WidgetTester tester) async {
    // Initialize mock shared preferences
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Build our app under ProviderScope with overridden preferences
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MyApp(),
      ),
    );

    // Let the authentication cache check resolve
    await tester.pumpAndSettle();

    // Verify that the login screen elements are displayed
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to your Global Green Tech account.'), findsOneWidget);
    expect(find.text('Sign In Securely'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
  });
}
