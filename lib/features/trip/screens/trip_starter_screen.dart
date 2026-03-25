import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TripStarterScreen extends StatefulWidget {
  final TripModel trip;

  const TripStarterScreen({super.key, required this.trip});

  @override
  State<TripStarterScreen> createState() => _TripStarterScreenState();
}

class _TripStarterScreenState extends State<TripStarterScreen> {
  GoogleMapController? _mapController;
  bool _locationLoading = true;

  // Currently focused stop index
  int _activeStopIndex = 0;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  List<StopModel> get _stopsWithLocation =>
      widget.trip.stops.where((s) => s.lat != null && s.lng != null).toList();

  @override
  void initState() {
    super.initState();
    _initLocationAndMap();
  }

  Future<void> _initLocationAndMap() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationLoading = false);
      _buildMapObjects();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (mounted) {
      setState(() => _locationLoading = false);
      _buildMapObjects();
    }
  }

  void _buildMapObjects() {
    final markers = <Marker>{};
    final polylinePoints = <LatLng>[];

    for (int i = 0; i < _stopsWithLocation.length; i++) {
      final stop = _stopsWithLocation[i];
      final pos = LatLng(stop.lat!, stop.lng!);
      polylinePoints.add(pos);

      // Determine marker color based on position in route
      double hue = BitmapDescriptor.hueCyan;
      if (i == 0) {
        hue = BitmapDescriptor.hueGreen; // Start
      } else if (i == _stopsWithLocation.length - 1) {
        hue = BitmapDescriptor.hueRed; // End
      } else if (i == _activeStopIndex) {
        hue = BitmapDescriptor.hueAzure; // Currently active/selected
      }

      markers.add(
        Marker(
          markerId: MarkerId('stop_$i'),
          position: pos,
          infoWindow: InfoWindow(
            title: '${stop.stopOrder}. ${stop.name}',
            snippet: stop.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }

    setState(() {
      _markers = markers;
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylinePoints,
          color: AppColors.primaryColor.withOpacity(0.7),
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          jointType: JointType.round,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
        ),
      };
    });
  }

  void _fitMapToBounds() {
    if (_stopsWithLocation.isEmpty || _mapController == null) return;
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (var s in _stopsWithLocation) {
      if (s.lat! < minLat) minLat = s.lat!;
      if (s.lat! > maxLat) maxLat = s.lat!;
      if (s.lng! < minLng) minLng = s.lng!;
      if (s.lng! > maxLng) maxLng = s.lng!;
    }
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.05, minLng - 0.05),
          northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
        ),
        80,
      ),
    );
  }

  void _flyToStop(int index) {
    if (index < 0 || index >= _stopsWithLocation.length) return;
    final stop = _stopsWithLocation[index];
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(stop.lat!, stop.lng!), zoom: 14),
      ),
    );
    setState(() => _activeStopIndex = index);
    _buildMapObjects();
  }

  /// Opens native Google Maps app with turn-by-turn directions to a single stop
  Future<void> _startNavigation(StopModel stop) async {
    final lat = stop.lat!;
    final lng = stop.lng!;

    Uri uri;
    if (Platform.isAndroid) {
      // Android: google.navigation opens Google Maps in navigation mode directly
      uri = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    } else {
      // iOS: comgooglemaps:// opens Google Maps app
      uri = Uri.parse(
        'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving',
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: web URL that prompts to open in Maps app
      final fallback = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$lat,$lng'
        '&travelmode=driving',
      );
      if (await canLaunchUrl(fallback)) {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Opens native Google Maps app with the full multi-stop route
  Future<void> _startFullRoute() async {
    if (_stopsWithLocation.isEmpty) return;

    final stops = _stopsWithLocation;
    final first = stops.first;
    final last = stops.last;

    // Build stop coordinates string for Google Maps
    final waypoints = stops.length > 2
        ? stops
              .sublist(1, stops.length - 1)
              .map((s) => '${s.lat},${s.lng}')
              .join('|')
        : null;

    Uri uri;
    if (Platform.isAndroid) {
      // Android intent URI — forces Google Maps app, not browser
      String intentUrl =
          'https://www.google.com/maps/dir/?api=1'
          '&origin=${first.lat},${first.lng}'
          '&destination=${last.lat},${last.lng}'
          '&travelmode=driving';
      if (waypoints != null) intentUrl += '&waypoints=$waypoints';

      uri = Uri.parse(
        'intent:$intentUrl'
        '#Intent;scheme=https;package=com.google.android.apps.maps;end',
      );
    } else {
      // iOS: comgooglemaps:// supports multi-stop via waypoints
      String iosUrl =
          'comgooglemaps://?saddr=${first.lat},${first.lng}'
          '&daddr=${last.lat},${last.lng}'
          '&directionsmode=driving';
      uri = Uri.parse(iosUrl);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: standard web URL
      String fallbackUrl =
          'https://www.google.com/maps/dir/?api=1'
          '&origin=${first.lat},${first.lng}'
          '&destination=${last.lat},${last.lng}'
          '&travelmode=driving';
      if (waypoints != null) fallbackUrl += '&waypoints=$waypoints';
      final fallbackUri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stops = _stopsWithLocation;
    final activeStop = stops.isNotEmpty ? stops[_activeStopIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.trip.tripName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.route_outlined, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${stops.length} Stops • Route Overview',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Fit all button
          GestureDetector(
            onTap: _fitMapToBounds,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.center_focus_strong_outlined,
                color: AppColors.primaryColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),

      body: _locationLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : Column(
              children: [
                // ── Google Map ───────────────────────────────────────────────
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: stops.isNotEmpty
                            ? CameraPosition(
                                target: LatLng(
                                  stops.first.lat!,
                                  stops.first.lng!,
                                ),
                                zoom: 10,
                              )
                            : const CameraPosition(
                                target: LatLng(7.8731, 80.7718),
                                zoom: 7,
                              ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          Future.delayed(
                            const Duration(milliseconds: 400),
                            _fitMapToBounds,
                          );
                        },
                      ),
                      // Floating My Location Button
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton.small(
                          heroTag: 'my_location',
                          onPressed: () async {
                            final pos = await Geolocator.getCurrentPosition();
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                LatLng(pos.latitude, pos.longitude),
                                14,
                              ),
                            );
                          },
                          backgroundColor: Colors.white,
                          elevation: 4,
                          child: const Icon(
                            Icons.my_location,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bottom Panel ─────────────────────────────────────────────
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          margin: const EdgeInsets.only(top: 14, bottom: 8),
                          width: 36,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        // Stop selector tabs
                        SizedBox(
                          height: 54,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: stops.length,
                            itemBuilder: (ctx, i) {
                              final isActive = i == _activeStopIndex;
                              return GestureDetector(
                                onTap: () => _flyToStop(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isActive
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      if (isActive)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      Text(
                                        'Stop ${stops[i].stopOrder}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isActive
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isActive
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Active stop info card
                        if (activeStop != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Number badge with gradient
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primaryColor,
                                            AppColors.lowPrimaryColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${activeStop.stopOrder}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Stop name + description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            activeStop.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            activeStop.description,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Navigate to this stop
                                    GestureDetector(
                                      onTap: () => _startNavigation(activeStop),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.near_me_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // ── Bottom action buttons ────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          child: Row(
                            children: [
                              // Start Full Route button (Premium Style)
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: stops.isNotEmpty
                                      ? _startFullRoute
                                      : null,
                                  child: Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          AppColors.lowPrimaryColor,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome_motion_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Start Full Journey',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Confirm button
                              Expanded(
                                flex: 2,
                                child: Consumer<TripProvider>(
                                  builder: (ctx, provider, _) =>
                                      GestureDetector(
                                        onTap: () async {
                                          await provider.updateTripStatus(
                                            widget.trip,
                                            'Active',
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.done_all_rounded,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Done',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ],
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
