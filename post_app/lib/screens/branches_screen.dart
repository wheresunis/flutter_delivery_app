import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/postal_office_card.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  static const _initialSheetSize = 0.33;
  static const _minSheetSize = 0.24;
  static const _maxSheetSize = 0.88;

  static const _buttonHideThreshold = _initialSheetSize + 0.02;

  static const _branches = [
    (
      branchNumber: '№1',
      address: 'вул. Хрещатик, 1',
      workingHours: '08:00 - 20:00',
    ),
  ];

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  bool _isSheetExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Пошук відділення...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Container(
                    color: const Color(0xFFF2F7F5),
                  ),
                  const Positioned(
                    top: 120,
                    left: 180,
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: AppColors.purple,
                    ),
                  ),
                  const Positioned(
                    top: 250,
                    left: 240,
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: AppColors.purple,
                    ),
                  ),
                  const Positioned(
                    top: 380,
                    left: 120,
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: AppColors.purple,
                    ),
                  ),
                  NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      final isExpanded =
                          notification.extent > BranchesScreen._buttonHideThreshold;
                      if (isExpanded != _isSheetExpanded) {
                        setState(() {
                          _isSheetExpanded = isExpanded;
                        });
                      }
                      return false;
                    },
                    child: DraggableScrollableSheet(
                    initialChildSize: BranchesScreen._initialSheetSize,
                    minChildSize: BranchesScreen._minSheetSize,
                    maxChildSize: BranchesScreen._maxSheetSize,
                    snap: true,
                    snapSizes: const [
                      BranchesScreen._initialSheetSize,
                      BranchesScreen._maxSheetSize,
                    ],
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 60,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Відділення поблизу',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                controller: scrollController,
                                itemCount: BranchesScreen._branches.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final branch = BranchesScreen._branches[index];
                                  return PostalOfficeCard(
                                    branchNumber: branch.branchNumber,
                                    address: branch.address,
                                    workingHours: branch.workingHours,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ),
                  Positioned(
                    right: 20,
                    bottom:
                        constraints.maxHeight * BranchesScreen._initialSheetSize +
                            20,
                    child: IgnorePointer(
                      ignoring: _isSheetExpanded,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: _isSheetExpanded ? 0 : 1,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 6,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.my_location,
                              color: AppColors.purple,
                            ),
                            tooltip: 'Моє місцезнаходження',
                          ),
                        ),
                      ),
                    ),
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