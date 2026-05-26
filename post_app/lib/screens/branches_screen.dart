import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/app_colors.dart';
import '../widgets/postal_office_card.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  static const _initialSheetSize = 0.32;
  static const _minSheetSize = 0.22;
  static const _maxSheetSize = 0.78;
  static const _buttonHideThreshold = _initialSheetSize + 0.03;
  static const _courierLocation = LatLng(50.446916, 30.515074);
  static const _deliveryAddress = LatLng(50.451372, 30.524776);
  static const _deliveryAddressText = 'вул. Велика Васильківська, 24';

  static const _branches = <_Branch>[
    _Branch(
      branchNumber: '№1',
      address: 'вул. Хрещатик, 1',
      workingHours: '08:00 - 20:00',
      distance: '0.5 км',
      workload: 'Мало людей',
      position: LatLng(50.450595, 30.523412),
    ),
    _Branch(
      branchNumber: '№2',
      address: 'вул. Саксаганського, 42',
      workingHours: '09:00 - 21:00',
      distance: '1.2 км',
      workload: 'Середньо',
      position: LatLng(50.439504, 30.514113),
    ),
    _Branch(
      branchNumber: '№3',
      address: 'просп. Перемоги, 18',
      workingHours: '08:30 - 19:30',
      distance: '1.8 км',
      workload: 'Мало людей',
      position: LatLng(50.449744, 30.491977),
    ),
  ];

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  var _selectedBranchIndex = 0;
  var _isSheetExpanded = false;
  GoogleMapController? _mapController;

  _Branch get _selectedBranch => BranchesScreen._branches[_selectedBranchIndex];

  Set<Marker> get _markers {
    return {
      Marker(
        markerId: const MarkerId('courier'),
        position: BranchesScreen._courierLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(
          title: 'Кур’єр',
          snippet: 'Прямує до адреси доставки',
        ),
      ),
      Marker(
        markerId: const MarkerId('delivery-address'),
        position: BranchesScreen._deliveryAddress,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: const InfoWindow(
          title: 'Адреса доставки',
          snippet: BranchesScreen._deliveryAddressText,
        ),
      ),
      for (var i = 0; i < BranchesScreen._branches.length; i++)
        Marker(
          markerId: MarkerId('branch-$i'),
          position: BranchesScreen._branches[i].position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            i == _selectedBranchIndex
                ? BitmapDescriptor.hueMagenta
                : BitmapDescriptor.hueRose,
          ),
          infoWindow: InfoWindow(
            title: 'Відділення ${BranchesScreen._branches[i].branchNumber}',
            snippet: BranchesScreen._branches[i].address,
          ),
          onTap: () => _selectBranch(i, animateCamera: false),
        ),
    };
  }

  Set<Polyline> get _polylines {
    return {
      Polyline(
        polylineId: const PolylineId('courier-route'),
        points: [
          BranchesScreen._courierLocation,
          _selectedBranch.position,
          BranchesScreen._deliveryAddress,
        ],
        color: AppColors.purple,
        width: 6,
        geodesic: true,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  void _selectBranch(int index, {bool animateCamera = true}) {
    setState(() {
      _selectedBranchIndex = index;
    });

    if (!animateCamera) {
      return;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        BranchesScreen._branches[index].position,
        14.6,
      ),
    );
  }

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
                    Positioned.fill(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedBranch.position,
                          zoom: 14.2,
                        ),
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        markers: _markers,
                        polylines: _polylines,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: false,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 16,
                      child: _DeliveryRouteCard(
                        selectedBranch: _selectedBranch,
                        deliveryAddress: BranchesScreen._deliveryAddressText,
                      ),
                    ),
                    NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        final isExpanded =
                            notification.extent >
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
                            onBranchSelected: _selectBranch,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 18,
                      bottom:
                          constraints.maxHeight *
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
                            shadowColor: AppColors.purple.withValues(
                              alpha: 0.24,
                            ),
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

class _DeliveryRouteCard extends StatelessWidget {
  const _DeliveryRouteCard({
    required this.selectedBranch,
    required this.deliveryAddress,
  });

  final _Branch selectedBranch;
  final String deliveryAddress;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.route_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Маршрут кур’єра',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedBranch.address} → $deliveryAddress',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
  final LatLng position;
}
