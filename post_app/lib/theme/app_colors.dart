import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF9D18F4);
  static const deepPurple = Color(0xFF7A20F0);
  static const blue = Color(0xFF3158FF);
  static const ink = Color(0xFF171827);
  static const muted = Color(0xFF7B8191);
  static const surface = Color(0xFFF7F5FB);
  static const line = Color(0xFFE7E2EF);
  static const mapBackground = Color(0xFFEFFBF8);
  static const success = Color(0xFF1DBE65);
  static const warning = Color(0xFFFF9A1F);

  static const gradient = LinearGradient(
    colors: [
      purple,
      blue,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
