import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/trip/widgets/new%20trip/date_stops_picker.dart';
import 'package:ride_lanka/features/trip/widgets/new%20trip/generated_stops_list.dart';
import 'package:ride_lanka/features/trip/widgets/new%20trip/preferences_card.dart';
import 'package:ride_lanka/features/trip/widgets/new%20trip/trip_name_input.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  int _stopCount = 3;
  final List<String> _selectedFavorites = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TripProvider>(context);

    // ── Generated Result View ────────────────────────────────────────────────
    if (provider.generatedStops.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bottomNavBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
          title: const Text(
            'Your Generated Route',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 240,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(7.8731, 80.7718),
                  zoom: 7.0,
                ),
                markers: provider.generatedStops
                    .where((s) => s.lat != null && s.lng != null)
                    .map(
                      (s) => Marker(
                        markerId: MarkerId(s.name),
                        position: LatLng(s.lat!, s.lng!),
                        infoWindow: InfoWindow(
                          title: s.name,
                          snippet: s.description,
                        ),
                      ),
                    )
                    .toSet(),
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  final withLoc = provider.generatedStops
                      .where((s) => s.lat != null && s.lng != null)
                      .toList();
                  if (withLoc.isNotEmpty) {
                    double minLat = 90,
                        maxLat = -90,
                        minLng = 180,
                        maxLng = -180;
                    for (var s in withLoc) {
                      if (s.lat! < minLat) minLat = s.lat!;
                      if (s.lat! > maxLat) maxLat = s.lat!;
                      if (s.lng! < minLng) minLng = s.lng!;
                      if (s.lng! > maxLng) maxLng = s.lng!;
                    }
                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                            southwest: LatLng(minLat, minLng),
                            northeast: LatLng(maxLat, maxLng),
                          ),
                          60,
                        ),
                      );
                    });
                  }
                },
              ),
            ),
            Expanded(child: GeneratedStopsList(stops: provider.generatedStops)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await provider.saveGeneratedTrip(
                      _nameController.text,
                      '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                      _stopCount,
                      _selectedFavorites,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Trip to My List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Form View ────────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Plan a New Trip',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TripNameInput(controller: _nameController),
            const SizedBox(height: 12),
            DateStopsPicker(
              selectedDate: _selectedDate,
              stopCount: _stopCount,
              onDatePicked: (d) => setState(() => _selectedDate = d),
              onStopCountChanged: (v) => setState(() => _stopCount = v),
            ),
            const SizedBox(height: 12),
            PreferencesCard(
              selectedFavorites: _selectedFavorites,
              onToggle: (id) => setState(() {
                _selectedFavorites.contains(id)
                    ? _selectedFavorites.remove(id)
                    : _selectedFavorites.add(id);
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lowPrimaryColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: provider.isGeneratingPlan
                    ? null
                    : () {
                        if (_nameController.text.isEmpty ||
                            _selectedDate == null ||
                            _selectedFavorites.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please fill all fields and pick at least one preference!',
                              ),
                              backgroundColor: AppColors.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          return;
                        }
                        provider.generatePlan(
                          tripName: _nameController.text,
                          tripDate:
                              '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                          stopCount: _stopCount,
                          favorites: _selectedFavorites,
                          preference: 'shortest',
                        );
                      },
                child: provider.isGeneratingPlan
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Generate Route with AI',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
