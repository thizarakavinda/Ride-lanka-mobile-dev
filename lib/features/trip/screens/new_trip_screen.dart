import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  final List<Map<String, dynamic>> _favoriteCategories = [
    {
      "title": "Activities",
      "options": [
        {"id": "hiking", "label": "Hiking"},
        {"id": "dance", "label": "Dancing"},
        {"id": "surfing", "label": "Surfing"},
        {"id": "safari", "label": "Safari"},
      ],
    },
    {
      "title": "Themes",
      "options": [
        {"id": "culture", "label": "Culture"},
        {"id": "nature", "label": "Nature"},
        {"id": "food", "label": "Food"},
        {"id": "relaxation", "label": "Relax"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TripProvider>(context);

    // If generatedStops exist, show the result view automatically!
    if (provider.generatedStops.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Your Generated Route')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.generatedStops.length,
                itemBuilder: (c, i) {
                  final s = provider.generatedStops[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${s.stopOrder}')),
                    title: Text(
                      s.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      s.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(7.8731, 80.7718), // Default to center of Sri Lanka
                  zoom: 7.0,
                ),
                markers: provider.generatedStops
                    .where((s) => s.lat != null && s.lng != null)
                    .map((s) => Marker(
                          markerId: MarkerId(s.name),
                          position: LatLng(s.lat!, s.lng!),
                          infoWindow: InfoWindow(title: s.name, snippet: s.description),
                        ))
                    .toSet(),
                onMapCreated: (controller) {
                  final stopsWithLocation = provider.generatedStops
                      .where((s) => s.lat != null && s.lng != null)
                      .toList();
                  if (stopsWithLocation.isNotEmpty) {
                    double minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
                    for (var s in stopsWithLocation) {
                      if (s.lat! < minLat) minLat = s.lat!;
                      if (s.lat! > maxLat) maxLat = s.lat!;
                      if (s.lng! < minLng) minLng = s.lng!;
                      if (s.lng! > maxLng) maxLng = s.lng!;
                    }
                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller.animateCamera(CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: LatLng(minLat, minLng),
                          northeast: LatLng(maxLat, maxLng),
                        ),
                        50, // padding
                      ));
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await provider.saveGeneratedTrip(
                    _nameController.text,
                    "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}",
                    _stopCount,
                    _selectedFavorites,
                  );
                  Navigator.pop(context); // Go back to list
                },
                child: Text(
                  'Save Trip to My List',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Trip (AI Planner)',
          style: TextStyle(color: Colors.teal.shade900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Trip Name',
                hintText: 'e.g., Sri Lanka Adventure',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Date Picker Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.calendar_today, color: Colors.teal),
                    label: Text(
                      _selectedDate == null
                          ? 'Pick Date'
                          : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                    ),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        setState(() {
                          _selectedDate = picked;
                        });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _stopCount,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: List.generate(
                      20,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1} Stops'),
                      ),
                    ),
                    onChanged: (val) => setState(() => _stopCount = val!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Favorites Selector
            Text(
              'Favorites / Preferences',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ..._favoriteCategories.map((cat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat['title'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (cat['options'] as List).map((opt) {
                      bool isSelected = _selectedFavorites.contains(opt['id']);
                      return FilterChip(
                        label: Text(opt['label']),
                        selected: isSelected,
                        selectedColor: Colors.teal.shade100,
                        onSelected: (val) {
                          setState(() {
                            if (val)
                              _selectedFavorites.add(opt['id']);
                            else
                              _selectedFavorites.remove(opt['id']);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),

            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: provider.isGeneratingPlan
                  ? null
                  : () {
                      if (_nameController.text.isEmpty ||
                          _selectedDate == null ||
                          _selectedFavorites.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill all fields and pick favorites!',
                            ),
                          ),
                        );
                        return;
                      }
                      provider.generatePlan(
                        tripName: _nameController.text,
                        tripDate:
                            "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}",
                        stopCount: _stopCount,
                        favorites: _selectedFavorites,
                        preference: 'shortest',
                      );
                    },
              child: provider.isGeneratingPlan
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Generate Route with AI  ✨',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
