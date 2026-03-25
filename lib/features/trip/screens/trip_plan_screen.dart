import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/trip/screens/trip_details_screen.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
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
      appBar: AppBar(
        title: Text(
          'Trips Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
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
            return Expanded(
              child: ListView.builder(
                itemCount: 5,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        height: 110,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          var displayedTrips = provider.myTrips;
          if (selectedFilter != 'All') {
            displayedTrips = displayedTrips
                .where((t) => t.status == selectedFilter)
                .toList();
          }

          return Column(
            children: [
              // Google Map showing Current Location
              SizedBox(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                          zoom: 14.0,
                        )
                      : const CameraPosition(
                          target: LatLng(6.9271, 79.8612), // Default to Colombo
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
                            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            zoom: 14.0,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: filters
                      .map(
                        (filter) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              filter,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            selected: selectedFilter == filter,
                            selectedColor: Colors.teal.shade100,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              // Trips List
              Expanded(
                child: displayedTrips.isEmpty
                    ? Center(
                        child: Text("No trips found. Click + to generate one!"),
                      )
                    : ListView.builder(
                        itemCount: displayedTrips.length,
                        itemBuilder: (context, index) {
                          final trip = displayedTrips[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TripDetailsScreen(trip: trip),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Placeholder Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        trip.stops.isNotEmpty &&
                                                trip.stops[0].photoUrl != null
                                            ? trip.stops[0].photoUrl!
                                            : 'https://images.unsplash.com/photo-1544487661-04e8d38cb71f?w=300&q=80',
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/imgplaceholder.jpg',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip.tripName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '📅 ${trip.tripDate} • 📍 ${trip.stopCount} stops',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: trip.status == 'Active'
                                                  ? Colors.green
                                                  : Colors.teal.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              trip.status,
                                              style: TextStyle(
                                                color: trip.status == 'Active'
                                                    ? Colors.white
                                                    : Colors.teal.shade900,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
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
          );
        },
      ),
    );
  }
}
