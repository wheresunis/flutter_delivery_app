import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple.withValues(alpha: 0.22),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Увійти',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Введіть ваші дані',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const _AuthField(
                        label: 'Телефон або Email',
                        hint: '+380 67 123 4567',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const _AuthField(
                        label: 'Пароль',
                        hint: '••••••••',
                        obscureText: true,
                      ),
                      const SizedBox(height: 22),
                      GradientButton(
                        text: 'Увійти',
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Забули пароль?',
                          style: TextStyle(
                            color: AppColors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Немає акаунту?',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Зареєструватись',
                              style: TextStyle(
                                color: AppColors.purple,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: AppColors.ink,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.4),
        ),
      ),
    );
  }
}
