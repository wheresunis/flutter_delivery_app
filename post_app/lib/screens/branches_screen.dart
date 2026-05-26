import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/postal_office_card.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  static const _initialSheetSize = 0.32;
  static const _minSheetSize = 0.22;
  static const _maxSheetSize = 0.78;
  static const _buttonHideThreshold = _initialSheetSize + 0.03;

  static const _branches = <_Branch>[
    _Branch(
      branchNumber: '№1',
      address: 'вул. Хрещатик, 1',
      workingHours: '08:00 - 20:00',
      distance: '0.5 км',
      workload: 'Мало людей',
      position: Offset(0.46, 0.27),
    ),
    _Branch(
      branchNumber: '№2',
      address: 'вул. Саксаганського, 42',
      workingHours: '09:00 - 21:00',
      distance: '1.2 км',
      workload: 'Середньо',
      position: Offset(0.67, 0.46),
    ),
    _Branch(
      branchNumber: '№3',
      address: 'просп. Перемоги, 18',
      workingHours: '08:30 - 19:30',
      distance: '1.8 км',
      workload: 'Мало людей',
      position: Offset(0.31, 0.62),
    ),
  ];

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  var _selectedBranchIndex = 0;
  var _isSheetExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mapBackground,
      body: Column(
        children: [
          _MapHeader(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    const Positioned.fill(
                      child: CustomPaint(painter: _DeliveryMapPainter()),
                    ),
                    for (var i = 0; i < BranchesScreen._branches.length; i++)
                      Positioned(
                        left: constraints.maxWidth *
                                BranchesScreen._branches[i].position.dx -
                            18,
                        top: constraints.maxHeight *
                                BranchesScreen._branches[i].position.dy -
                            44,
                        child: _BranchMarker(
                          label: BranchesScreen._branches[i].branchNumber,
                          selected: _selectedBranchIndex == i,
                          onTap: () {
                            setState(() {
                              _selectedBranchIndex = i;
                            });
                          },
                        ),
                      ),
                    NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        final isExpanded = notification.extent >
                            BranchesScreen._buttonHideThreshold;
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
                          return _NearbyBranchesSheet(
                            branches: BranchesScreen._branches,
                            scrollController: scrollController,
                            selectedIndex: _selectedBranchIndex,
                            onBranchSelected: (index) {
                              setState(() {
                                _selectedBranchIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 18,
                      bottom: constraints.maxHeight *
                              BranchesScreen._initialSheetSize +
                          16,
                      child: IgnorePointer(
                        ignoring: _isSheetExpanded,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: _isSheetExpanded ? 0 : 1,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 10,
                            shadowColor: AppColors.purple.withValues(alpha: 0.24),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.near_me_rounded,
                                color: AppColors.purple,
                              ),
                              tooltip: 'Моє місцезнаходження',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(18, topPadding + 12, 18, 14),
      decoration: const BoxDecoration(gradient: AppColors.gradient),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.18),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              tooltip: 'Назад',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Пошук відділення...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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

class _NearbyBranchesSheet extends StatelessWidget {
  const _NearbyBranchesSheet({
    required this.branches,
    required this.scrollController,
    required this.selectedIndex,
    required this.onBranchSelected,
  });

  final List<_Branch> branches;
  final ScrollController scrollController;
  final int selectedIndex;
  final ValueChanged<int> onBranchSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 28,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Відділення поблизу',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${branches.length} поруч',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: branches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final branch = branches[index];
                return GestureDetector(
                  onTap: () => onBranchSelected(index),
                  child: PostalOfficeCard(
                    branchNumber: branch.branchNumber,
                    address: branch.address,
                    workingHours: branch.workingHours,
                    distance: branch.distance,
                    workload: branch.workload,
                    selected: selectedIndex == index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchMarker extends StatelessWidget {
  const _BranchMarker({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: selected ? 1.14 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity: selected ? 1 : 0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryMapPainter extends CustomPainter {
  const _DeliveryMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = AppColors.mapBackground;
    canvas.drawRect(Offset.zero & size, background);

    _drawWater(canvas, size);
    _drawParkBlocks(canvas, size);
    _drawRoads(canvas, size);
    _drawDeliveryRoute(canvas, size);
    _drawMapLabels(canvas, size);
  }

  void _drawWater(Canvas canvas, Size size) {
    final riverPaint = Paint()
      ..color = const Color(0xFFD9F1FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 44
      ..strokeCap = StrokeCap.round;

    final river = Path()
      ..moveTo(size.width * 0.02, size.height * 0.18)
      ..cubicTo(
        size.width * 0.27,
        size.height * 0.1,
        size.width * 0.47,
        size.height * 0.26,
        size.width * 0.66,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.8,
        size.height * 0.09,
        size.width * 0.88,
        size.height * 0.18,
        size.width,
        size.height * 0.12,
      );
    canvas.drawPath(river, riverPaint);
  }

  void _drawParkBlocks(Canvas canvas, Size size) {
    final parkPaint = Paint()..color = AppColors.success.withValues(alpha: 0.08);
    final blocks = [
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.36,
        size.width * 0.22,
        size.height * 0.14,
      ),
      Rect.fromLTWH(
        size.width * 0.71,
        size.height * 0.25,
        size.width * 0.18,
        size.height * 0.12,
      ),
      Rect.fromLTWH(
        size.width * 0.55,
        size.height * 0.64,
        size.width * 0.28,
        size.height * 0.12,
      ),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(18)),
        parkPaint,
      );
    }
  }

  void _drawRoads(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;
    final roadLinePaint = Paint()
      ..color = AppColors.line.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    final roads = [
      Path()
        ..moveTo(-20, size.height * 0.5)
        ..quadraticBezierTo(
          size.width * 0.36,
          size.height * 0.4,
          size.width + 20,
          size.height * 0.5,
        ),
      Path()
        ..moveTo(size.width * 0.18, -20)
        ..cubicTo(
          size.width * 0.25,
          size.height * 0.18,
          size.width * 0.14,
          size.height * 0.43,
          size.width * 0.34,
          size.height * 0.82,
        ),
      Path()
        ..moveTo(size.width * 0.78, -20)
        ..cubicTo(
          size.width * 0.7,
          size.height * 0.26,
          size.width * 0.92,
          size.height * 0.48,
          size.width * 0.6,
          size.height + 20,
        ),
      Path()
        ..moveTo(-20, size.height * 0.74)
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height * 0.64,
          size.width + 20,
          size.height * 0.82,
        ),
    ];

    for (final road in roads) {
      canvas.drawPath(road, roadPaint);
      canvas.drawPath(road, roadLinePaint);
    }
  }

  void _drawDeliveryRoute(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = AppColors.purple.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    final routePaint = Paint()
      ..color = AppColors.purple.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final route = Path()
      ..moveTo(size.width * 0.31, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.43,
        size.width * 0.46,
        size.height * 0.27,
      )
      ..quadraticBezierTo(
        size.width * 0.56,
        size.height * 0.36,
        size.width * 0.67,
        size.height * 0.46,
      );

    canvas.drawPath(route, shadowPaint);
    canvas.drawPath(route, routePaint);
  }

  void _drawMapLabels(Canvas canvas, Size size) {
    _drawLabel(canvas, 'Центр', Offset(size.width * 0.2, size.height * 0.31));
    _drawLabel(canvas, 'Поштова площа', Offset(size.width * 0.54, size.height * 0.2));
    _drawLabel(canvas, 'Парк', Offset(size.width * 0.13, size.height * 0.43));
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.muted.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Branch {
  const _Branch({
    required this.branchNumber,
    required this.address,
    required this.workingHours,
    required this.distance,
    required this.workload,
    required this.position,
  });

  final String branchNumber;
  final String address;
  final String workingHours;
  final String distance;
  final String workload;
  final Offset position;
}
