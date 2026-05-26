import 'package:flutter/material.dart';
import 'screens/load_screen.dart';

void main() {
  runApp(const PurpleDeliveryApp());
}

class PurpleDeliveryApp extends StatelessWidget {
  const PurpleDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purple Delivery',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9D18F4),
          primary: const Color(0xFF9D18F4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FB),
        useMaterial3: true,
      ),
      home: const LoadScreen(),
    );
  }
}
