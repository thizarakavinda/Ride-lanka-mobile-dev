import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
// We make this below

class TripPlanScreen extends StatefulWidget {
  @override
  _TripPlanScreenState createState() => _TripPlanScreenState();
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
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
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
            icon: Icon(Icons.add_circle, color: Colors.teal, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.newTrpPlanScreen);
            },
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingTrips) {
            return ListView.builder(
              itemCount: 5,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
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
                );
              },
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
                  // Google Map showing Current Location (Bottom Layer)
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
                              target: LatLng(
                                6.9271,
                                79.8612,
                              ), // Default to Colombo
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

                  // Rounded Container Overlapping the Map
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
                          // Drag Handle Indicator
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

                          // Filter Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: filters.map((filter) {
                                final isSelected = selectedFilter == filter;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = filter;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : AppColors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        filter,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255,
                                                  90,
                                                  90,
                                                  90,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Trips List
                          Expanded(
                            child: displayedTrips.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No trips found. Click + to generate one!",
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: displayedTrips.length,
                                    padding: const EdgeInsets.only(top: 0),
                                    itemBuilder: (context, index) {
                                      final trip = displayedTrips[index];
                                      return Card(
                                        color: AppColors.white,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 2,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.tripDetails,
                                              arguments: {'trip': trip},
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                // Placeholder Image
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    trip.stops.isNotEmpty &&
                                                            trip
                                                                    .stops[0]
                                                                    .photoUrl !=
                                                                null
                                                        ? trip
                                                              .stops[0]
                                                              .photoUrl!
                                                        : 'https://images.unsplash.com/photo-1544487661-04e8d38cb71f?w=300&q=80',
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder:
                                                        (
                                                          context,
                                                          child,
                                                          loadingProgress,
                                                        ) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey
                                                                .shade300,
                                                            highlightColor:
                                                                Colors
                                                                    .grey
                                                                    .shade100,
                                                            child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        },
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Image.asset(
                                                            'assets/images/imgplaceholder.jpg',
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        trip.tripName,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            size: 16,
                                                            color: AppColors
                                                                .forgotPasswordText,
                                                          ),
                                                          Text(
                                                            ' ${trip.tripDate}',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Icon(
                                                            Icons.location_on,
                                                            size: 16,
                                                            color: AppColors
                                                                .favoriteColor,
                                                          ),
                                                          Text(
                                                            '${trip.stopCount} stops',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              trip.status ==
                                                                  'Active'
                                                              ? Colors.green
                                                              : AppColors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          trip.status,
                                                          style: TextStyle(
                                                            color:
                                                                trip.status ==
                                                                    'Active'
                                                                ? Colors.white
                                                                : Colors
                                                                      .teal
                                                                      .shade900,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
