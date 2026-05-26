import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'login_screen.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), _openLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openLogin() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLogin,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.gradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 54,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Purple Delivery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Швидка доставка по Україні',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
