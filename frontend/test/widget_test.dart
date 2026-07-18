import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/language_provider.dart';

void main() {

  // Run before every test — mock SharedPreferences
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // Helper — builds app with a fresh LanguageProvider
  Widget buildApp({String initialLanguage = 'en'}) {
    final provider = LanguageProvider();
    provider.setLanguage(initialLanguage);
    return ChangeNotifierProvider.value(
      value: provider,
      child: const LemonApp(),
    );
  }

  // ── Test 1 ────────────────────────────────────────────────────
  testWidgets('App launches and shows English title', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Lemon Disease Detector'), findsOneWidget);
  });

  // ── Test 2 ────────────────────────────────────────────────────
  testWidgets('Home screen shows Scan and Upload buttons', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Open Camera'),  findsOneWidget);
    expect(find.text('Browse Files'), findsOneWidget);
  });

  // ── Test 3 ────────────────────────────────────────────────────
  testWidgets('Tips section is visible', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('For best results'), findsOneWidget);
  });

  // ── Test 4 ────────────────────────────────────────────────────
  testWidgets('Language toggles from EN to NP correctly', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Default is English
    expect(find.text('Lemon Disease Detector'), findsOneWidget);
    expect(find.text('NP'), findsOneWidget);

    // Tap NP toggle
    await tester.tap(find.text('NP'));
    await tester.pump();        // trigger setState
    await tester.pump();        // rebuild UI

    // Verify language switched to Nepali
    expect(find.text('EN'), findsOneWidget);
  });

  // ── Test 5 ────────────────────────────────────────────────────
  testWidgets('App starts in Nepali when language set to np', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp(initialLanguage: 'np'));
    await tester.pumpAndSettle();

    // Title should be in Nepali
    expect(find.text('कागती रोग पहिचानकर्ता'), findsOneWidget);
    // Toggle button should show EN
    expect(find.text('EN'), findsOneWidget);
  });

  // ── Test 6 ────────────────────────────────────────────────────
  testWidgets('Nepali buttons show correct text', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp(initialLanguage: 'np'));
    await tester.pumpAndSettle();

    // Buttons should be in Nepali
    expect(find.text('क्यामेरा खोल्नुहोस्'), findsOneWidget);
    expect(find.text('फाइल खोज्नुहोस्'),    findsOneWidget);
  });

  // ── Test 7 ────────────────────────────────────────────────────
  testWidgets('Scan button is tappable without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Tap Open Camera — on Linux test it shows dialog, should not crash
    await tester.tap(find.text('Open Camera'));
    await tester.pumpAndSettle();

    // App still running — either dialog appeared or nothing crashed
    expect(find.byType(MaterialApp), findsOneWidget);
  });

}