import 'package:flutter/material.dart';
import 'screens/session_screen.dart';

void main() {
  runApp(const YogaApp());
}

class YogaApp extends StatelessWidget {
  const YogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const YogaSessionScreen(),
    );
  }
}