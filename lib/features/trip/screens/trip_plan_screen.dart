import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20plan/trip_filter_chips.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20plan/trip_list_card.dart';

import 'package:ride_lanka/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class TripPlanScreen extends StatefulWidget {
  const TripPlanScreen({super.key});

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Upcoming', 'Active', 'Completed'];
  GoogleMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).fetchUserTrips();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() => _currentPosition = position);
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Trips Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.teal, size: 28),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.newTrpPlanScreen),
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingTrips) {
            return ListView.builder(
              itemCount: 5,
              padding: EdgeInsets.zero,
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(height: 110, width: double.infinity),
                ),
              ),
            );
          }

          var displayedTrips = provider.myTrips;
          if (selectedFilter != 'All') {
            displayedTrips = displayedTrips
                .where((t) => t.status == selectedFilter)
                .toList();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: constraints.maxHeight * 0.5,
                    child: GoogleMap(
                      initialCameraPosition: _currentPosition != null
                          ? CameraPosition(
                              target: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              zoom: 14.0,
                            )
                          : const CameraPosition(
                              target: LatLng(6.9271, 79.8612),
                              zoom: 10.0,
                            ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                        if (_currentPosition != null) {
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                zoom: 14.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.45,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 16, bottom: 8),
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          TripFilterChips(
                            selectedFilter: selectedFilter,
                            filters: filters,
                            onFilterChanged: (f) =>
                                setState(() => selectedFilter = f),
                          ),
                          Expanded(
                            child: displayedTrips.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No trips found. Click + to generate one!',
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () =>
                                        provider.fetchUserTrips(force: true),
                                    color: AppColors.primaryColor,
                                    child: ListView.builder(
                                      itemCount: displayedTrips.length,
                                      padding: const EdgeInsets.only(top: 0),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics(),
                                          ),
                                      itemBuilder: (context, index) {
                                        final trip = displayedTrips[index];
                                        return TripListCard(
                                          trip: trip,
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            AppRoutes.tripDetails,
                                            arguments: {'trip': trip},
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
