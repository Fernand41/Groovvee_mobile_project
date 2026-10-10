// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:groovvee/screens/signin_screen.dart';
import 'package:groovvee/screens/signup_screen.dart';

void main() {
  testWidgets('signup password can be hidden and shown', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

    expect(find.text('Create your account'), findsOneWidget);
    await _verifyPasswordVisibilityToggle(tester, passwordFieldIndex: 3);
  });

  testWidgets('signin password can be hidden and shown', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SigninScreen()));

    expect(find.text('Login to your Account'), findsOneWidget);
    await _verifyPasswordVisibilityToggle(tester, passwordFieldIndex: 1);
  });

  testWidgets(
    'signup requires uppercase, lowercase, digit, and special character',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Ada');
      await tester.enterText(fields.at(1), 'Lovelace');
      await tester.enterText(fields.at(2), 'ada@example.com');

      final passwordField = fields.at(3);
      final submitButton = find.text('Sign Up');
      final invalidPasswords = <String, String>{
        'abcdef1!': '1 majuscule minimum',
        'ABCDEF1!': '1 minuscule minimum',
        'Abcdef12': '1 caractère spécial minimum',
        'Abcdefg!': '1 chiffre minimum',
        'Ab1!': '8 caractères minimum',
      };

      for (final entry in invalidPasswords.entries) {
        await tester.ensureVisible(passwordField);
        await tester.enterText(passwordField, entry.key);
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pump();

        expect(find.text(entry.value), findsOneWidget, reason: entry.key);
      }
    },
  );
}

Future<void> _verifyPasswordVisibilityToggle(
  WidgetTester tester, {
  required int passwordFieldIndex,
}) async {
  final passwordField = find.byType(TextFormField).at(passwordFieldIndex);
  final editableText = find.descendant(
    of: passwordField,
    matching: find.byType(EditableText),
  );

  await tester.enterText(passwordField, 'VisiblePassword1!');
  await tester.pump();

  expect(tester.widget<EditableText>(editableText).obscureText, isTrue);
  expect(find.byTooltip('Show password'), findsOneWidget);

  await tester.tap(find.byTooltip('Show password'));
  await tester.pump();

  expect(tester.widget<EditableText>(editableText).obscureText, isFalse);
  expect(find.byTooltip('Hide password'), findsOneWidget);

  await tester.tap(find.byTooltip('Hide password'));
  await tester.pump();

  expect(tester.widget<EditableText>(editableText).obscureText, isTrue);
}
