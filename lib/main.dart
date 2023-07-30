import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CashCompass());
}

class CashCompass extends StatelessWidget {
  const CashCompass({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: customSwatch,
      colorScheme: const ColorScheme.light().copyWith(
        primary: customColorPrimary,
        secondary: customColorPrimary,
        tertiary: customColorPrimary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
      ),
    );

    return MaterialApp(
        title: 'CashCompass', theme: theme, home: const SplashScreen());
  }
}
