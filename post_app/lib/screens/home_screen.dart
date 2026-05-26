import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/quick_action_item.dart';
import '../widgets/shipment_card.dart';
import 'branches_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openBranches(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BranchesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: AppColors.muted,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        currentIndex: 0,
        backgroundColor: Colors.white,
        elevation: 18,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Пошук',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Створити',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Історія',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профіль',
          ),
        ],
      ),
      body: Column(
        children: [
          _HomeHeader(onBranchesTap: () => _openBranches(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Мої відправлення',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Усі',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const ShipmentCard(
                  number: '20450123456789',
                  route: 'Київ → Львів',
                  status: 'У дорозі',
                  statusColor: AppColors.warning,
                  date: 'Сьогодні',
                  price: '65 грн',
                ),
                const ShipmentCard(
                  number: '20450123456788',
                  route: 'Одеса → Київ',
                  status: 'Доставлено',
                  statusColor: AppColors.success,
                  date: 'Учора',
                  price: '45 грн',
                ),
                const SizedBox(height: 8),
                _MapShortcutCard(onTap: () => _openBranches(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onBranchesTap});

  final VoidCallback onBranchesTap;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: topPadding + 186,
      child: Stack(
        children: [
          Container(
            height: topPadding + 148,
            padding: EdgeInsets.fromLTRB(20, topPadding + 18, 20, 0),
            decoration: const BoxDecoration(gradient: AppColors.gradient),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Головна',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Доброго дня!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _HeaderIconButton(
                  icon: Icons.notifications_none_rounded,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _HeaderIconButton(
                  icon: Icons.person_outline_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  QuickActionItem(
                    icon: Icons.search_rounded,
                    title: 'Відстежити',
                    onTap: () {},
                  ),
                  QuickActionItem(
                    icon: Icons.qr_code_rounded,
                    title: 'QR-код',
                    onTap: () {},
                  ),
                  QuickActionItem(
                    icon: Icons.location_on_outlined,
                    title: 'Відділення',
                    onTap: onBranchesTap,
                  ),
                  QuickActionItem(
                    icon: Icons.calculate_outlined,
                    title: 'Калькулятор',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        tooltip: '',
      ),
    );
  }
}

class _MapShortcutCard extends StatelessWidget {
  const _MapShortcutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Відділення поруч',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Знайдіть найближчу точку на мапі',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Text(
                            'Відкрити мапу',
                            style: TextStyle(
                              color: AppColors.purple,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: CustomPaint(
                  painter: _MiniMapPainter(),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.purple,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = AppColors.mapBackground;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      background,
    );

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final accentRoad = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.48,
        size.width * 0.86,
        size.height * 0.55,
      );
    canvas.drawPath(path, road);
    canvas.drawPath(path, accentRoad);

    canvas.drawCircle(
      Offset(size.width * 0.24, size.height * 0.26),
      14,
      Paint()..color = AppColors.success.withValues(alpha: 0.12),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
