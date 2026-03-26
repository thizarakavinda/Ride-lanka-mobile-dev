import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20starter/active_stop_card.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20starter/route_action_bar.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20starter/stop_selector_tabs.dart';

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
  int _activeStopIndex = 0;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  List<StopModel> get _stops =>
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

    for (int i = 0; i < _stops.length; i++) {
      final stop = _stops[i];
      final pos = LatLng(stop.lat!, stop.lng!);
      polylinePoints.add(pos);

      double hue = BitmapDescriptor.hueCyan;
      if (i == 0)
        hue = BitmapDescriptor.hueGreen;
      else if (i == _stops.length - 1)
        hue = BitmapDescriptor.hueRed;
      else if (i == _activeStopIndex)
        hue = BitmapDescriptor.hueAzure;

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
    if (_stops.isEmpty || _mapController == null) return;
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (var s in _stops) {
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
    if (index < 0 || index >= _stops.length) return;
    final stop = _stops[index];
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(stop.lat!, stop.lng!), zoom: 14),
      ),
    );
    setState(() => _activeStopIndex = index);
    _buildMapObjects();
  }

  Future<void> _startNavigation(StopModel stop) async {
    final lat = stop.lat!;
    final lng = stop.lng!;
    Uri uri;
    if (Platform.isAndroid) {
      uri = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    } else {
      uri = Uri.parse(
        'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving',
      );
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final fallback = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
      );
      if (await canLaunchUrl(fallback)) {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _startFullRoute() async {
    if (_stops.isEmpty) return;
    final first = _stops.first;
    final last = _stops.last;
    final waypoints = _stops.length > 2
        ? _stops
              .sublist(1, _stops.length - 1)
              .map((s) => '${s.lat},${s.lng}')
              .join('|')
        : null;

    Uri uri;
    if (Platform.isAndroid) {
      String intentUrl =
          'https://www.google.com/maps/dir/?api=1&origin=${first.lat},${first.lng}&destination=${last.lat},${last.lng}&travelmode=driving';
      if (waypoints != null) intentUrl += '&waypoints=$waypoints';
      uri = Uri.parse(
        'intent:$intentUrl#Intent;scheme=https;package=com.google.android.apps.maps;end',
      );
    } else {
      uri = Uri.parse(
        'comgooglemaps://?saddr=${first.lat},${first.lng}&daddr=${last.lat},${last.lng}&directionsmode=driving',
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      String fallbackUrl =
          'https://www.google.com/maps/dir/?api=1&origin=${first.lat},${first.lng}&destination=${last.lat},${last.lng}&travelmode=driving';
      if (waypoints != null) fallbackUrl += '&waypoints=$waypoints';
      final fallbackUri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stops = _stops;
    final activeStop = stops.isNotEmpty ? stops[_activeStopIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
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
                        Container(
                          margin: const EdgeInsets.only(top: 14, bottom: 8),
                          width: 36,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        StopSelectorTabs(
                          stops: stops,
                          activeIndex: _activeStopIndex,
                          onStopSelected: _flyToStop,
                        ),
                        const SizedBox(height: 8),
                        if (activeStop != null)
                          Expanded(
                            child: ActiveStopCard(
                              stop: activeStop,
                              onNavigate: () => _startNavigation(activeStop),
                            ),
                          ),
                        const SizedBox(height: 12),
                        RouteActionBar(
                          trip: widget.trip,
                          hasStops: stops.isNotEmpty,
                          onStartFullRoute: _startFullRoute,
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
