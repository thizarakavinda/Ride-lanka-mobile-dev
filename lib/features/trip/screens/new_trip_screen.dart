import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
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
        {"id": "hiking", "label": " Hiking"},
        {"id": "dance", "label": "Dancing"},
        {"id": "surfing", "label": " Surfing"},
        {"id": "safari", "label": " Safari"},
      ],
    },
    {
      "title": "Themes",
      "options": [
        {"id": "culture", "label": " Culture"},
        {"id": "nature", "label": " Nature"},
        {"id": "food", "label": " Food"},
        {"id": "relaxation", "label": " Relax"},
      ],
    },
  ];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TripProvider>(context);

    // ── Generated Result View ─────────────────────────────────────────────────
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
            // Map showing all stop markers
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

            // Stops list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: provider.generatedStops.length,
                itemBuilder: (c, i) {
                  final s = provider.generatedStops[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryColor,
                          child: Text(
                            '${s.stopOrder}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Save button
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

    // ── Form View ─────────────────────────────────────────────────────────────
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Trip Name card ───────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Trip Name', icon: Icons.edit_note),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Sri Lanka Adventure',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: AppColors.bottomNavBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Date & Stops card ────────────────────────────────────────────
            _SectionCard(
              child: Row(
                children: [
                  // Date picker
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(
                          label: 'Date',
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primaryColor,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bottomNavBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? 'Pick a date'
                                      : _formatDate(_selectedDate!),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _selectedDate == null
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Stops dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'Stops', icon: Icons.place),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.bottomNavBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _stopCount,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primaryColor,
                              ),
                              items: List.generate(
                                20,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text(
                                    '${i + 1} Stop${i == 0 ? '' : 's'}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              onChanged: (val) =>
                                  setState(() => _stopCount = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Preferences card ─────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(
                    label: 'Favorites & Preferences',
                    icon: Icons.favorite_border,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose what you enjoy to personalise your route',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  ..._favoriteCategories.map((cat) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (cat['options'] as List).map((opt) {
                            final bool isSelected = _selectedFavorites.contains(
                              opt['id'],
                            );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected)
                                    _selectedFavorites.remove(opt['id']);
                                  else
                                    _selectedFavorites.add(opt['id']);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.lowPrimaryColor
                                      : AppColors.chipBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  opt['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Generate Button ──────────────────────────────────────────────
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

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
