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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoadScreen(),
    );
  }
}