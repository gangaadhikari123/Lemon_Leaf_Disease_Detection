import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/language_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final langProvider = LanguageProvider();
  await langProvider.loadSavedLanguage();
  runApp(
    ChangeNotifierProvider.value(
      value: langProvider,
      child: const LemonApp(),
    ),
  );
}

class LemonApp extends StatelessWidget {
  const LemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lemon Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}