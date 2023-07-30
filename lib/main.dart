import 'package:cash_compass/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CashCompass());
}

class CashCompass extends StatelessWidget {
  const CashCompass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cash Compass',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const SplashScreen());
  }
}
