import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/main_navigation_screen.dart';

void main() {
  runApp(const ShoryanApp());
}

class ShoryanApp extends StatelessWidget {
  const ShoryanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoryan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNavigationScreen(),
    );
  }
}
