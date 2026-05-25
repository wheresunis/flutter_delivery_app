import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/quick_action_item.dart';
import '../widgets/shipment_card.dart';
import 'branches_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Пошук',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
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
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Головна',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Доброго дня!',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      QuickActionItem(
                        icon: Icons.search,
                        title: 'Відстежити',
                      ),
                      QuickActionItem(
                        icon: Icons.qr_code,
                        title: 'QR-код',
                      ),
                      QuickActionItem(
                        icon: Icons.location_on_outlined,
                        title: 'Відділення',
                      ),
                      QuickActionItem(
                        icon: Icons.calculate_outlined,
                        title: 'Калькулятор',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Мої відправлення',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ShipmentCard(
                    number: '20450123456789',
                    route: 'Київ → Львів',
                    status: 'У дорозі',
                    statusColor: Colors.orange,
                  ),
                  const ShipmentCard(
                    number: '20450123456788',
                    route: 'Одеса → Київ',
                    status: 'Доставлено',
                    statusColor: Colors.green,
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BranchesScreen(),
                          ),
                        );
                      },
                      child: const Text('Відділення'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}