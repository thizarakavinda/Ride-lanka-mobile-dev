import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:ride_lanka/features/home/models/explore_place_model.dart';
import 'package:ride_lanka/features/home/models/nearby_place_model.dart';
import 'package:ride_lanka/features/home/models/popular_place_model.dart';
import 'package:ride_lanka/features/home/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();
  final Logger _logger = Logger();

  // ── Nearby / Popular ──────────────────────────────────────────────────────
  List<NearbyPlaceModel> _nearbyPlaces = [];
  List<NearbyPlaceModel> get nearbyPlaces => _nearbyPlaces;

  List<PopularPlaceModel> _popularPlaces = [];
  List<PopularPlaceModel> get popularPlaces => _popularPlaces;

  // ── Category filter ───────────────────────────────────────────────────────
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  List<ExplorePlaceModel> _categoryPlaces = [];
  List<ExplorePlaceModel> get categoryPlaces => _categoryPlaces;

  bool _isCategoryLoading = false;
  bool get isCategoryLoading => _isCategoryLoading;

  // ── Search ────────────────────────────────────────────────────────────────
  List<ExplorePlaceModel> _searchResults = [];
  List<ExplorePlaceModel> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ── General ───────────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _userName = 'Traveller';
  String get userName => _userName;

  String _currentLocationName = 'Location Unknown';
  String get currentLocationName => _currentLocationName;

  // ── Fetch home data (Nearby + Popular from `places`) ─────────────────────
  Future<void> fetchHomeData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Fetch user name from Firestore users collection
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          final userSnap = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (userSnap.exists) {
            final userData = userSnap.data();
            final name = userData?['name'] as String?;
            if (name != null && name.trim().isNotEmpty) {
              _userName = name.trim().split(' ').first;
            }
          }
        }
      } catch (e) {
        _logger.e('fetchUserName error: $e');
      }

      // Fetch location
      Position? position;
      try {
        position = await _determinePosition();
        _logger.i('Got position: ${position.latitude}, ${position.longitude}');
        try {
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final pm = placemarks.first;
            final city = pm.locality?.isNotEmpty == true
                ? pm.locality
                : pm.subAdministrativeArea?.isNotEmpty == true
                ? pm.subAdministrativeArea
                : pm.administrativeArea?.isNotEmpty == true
                ? pm.administrativeArea
                : null;
            final country = pm.country?.isNotEmpty == true
                ? pm.country
                : 'Sri Lanka';
            _currentLocationName = city != null ? '$city, $country' : country!;
          }
        } catch (e) {
          _logger.e('Geocoding error: $e');
          _currentLocationName =
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        }
      } catch (e) {
        _logger.e('Location error: $e');
        _currentLocationName = 'Location Unknown';
      }

      // Fetch places
      final docs = await _homeService.fetchPlaces();
      final List<Map<String, dynamic>> placesWithDistances = [];

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        double distanceMeters = double.infinity;
        String distanceStr = 'N/A';

        if (position != null &&
            data['latitude'] != null &&
            data['longitude'] != null) {
          distanceMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            data['latitude'] as double,
            data['longitude'] as double,
          );
          distanceStr = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
        }

        placesWithDistances.add({
          'doc': doc,
          'distance': distanceMeters,
          'distanceStr': distanceStr,
          'popularity': data['popularityScore'] ?? 0,
        });
      }

      // Sort Nearby — closest first
      final nearbyList = List<Map<String, dynamic>>.from(placesWithDistances);
      nearbyList.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );
      _nearbyPlaces = nearbyList
          .take(5)
          .map(
            (p) => NearbyPlaceModel.fromFirestore(
              p['doc'] as DocumentSnapshot,
              calculatedDistance: p['distanceStr'] as String,
            ),
          )
          .toList();

      // Sort Popular — highest popularityScore first
      final popularList = List<Map<String, dynamic>>.from(placesWithDistances);
      popularList.sort(
        (a, b) => (b['popularity'] as num).compareTo(a['popularity'] as num),
      );
      _popularPlaces = popularList
          .map(
            (p) => PopularPlaceModel.fromFirestore(
              p['doc'] as DocumentSnapshot,
              calculatedDistance: p['distanceStr'] as String,
            ),
          )
          .toList();
    } catch (e) {
      _logger.e('fetchHomeData error: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Category filter ───────────────────────────────────────────────────────
  Future<void> selectCategory(String category) async {
    // Tap same category again → deselect
    if (_selectedCategory == category) {
      _selectedCategory = null;
      _categoryPlaces = [];
      notifyListeners();
      return;
    }

    _selectedCategory = category;
    _isCategoryLoading = true;
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();

    try {
      _categoryPlaces = await _homeService.fetchExplorePlacesByCategory(
        category,
      );
    } catch (e) {
      _logger.e('fetchExplorePlacesByCategory error: $e');
      _categoryPlaces = [];
    } finally {
      _isCategoryLoading = false;
      notifyListeners();
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────
  Future<void> searchPlaces(String query) async {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _selectedCategory = null;
      _categoryPlaces = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _selectedCategory = null;
    _categoryPlaces = [];
    notifyListeners();

    try {
      _searchResults = await _homeService.searchExplorePlaces(query);
    } catch (e) {
      _logger.e('searchPlaces error: $e');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    _selectedCategory = null;
    _categoryPlaces = [];
    notifyListeners();
  }

  // ── Location ──────────────────────────────────────────────────────────────
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }
}
