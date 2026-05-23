import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF8A2BE2);
  static const blue = Color(0xFF3B49FF);

  static const gradient = LinearGradient(
    colors: [
      purple,
      blue,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}