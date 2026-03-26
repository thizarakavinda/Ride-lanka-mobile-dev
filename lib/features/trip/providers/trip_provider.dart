import 'package:flutter/foundation.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/services/trip_service.dart';

class TripProvider extends ChangeNotifier {
  final TripService _tripService;

  List<TripModel> myTrips = [];
  bool isLoadingTrips = false;

  bool isGeneratingPlan = false;
  List<StopModel> generatedStops = [];
  String routePreference = 'shortest';

  TripProvider(this._tripService);

  Future<void> fetchUserTrips() async {
    isLoadingTrips = true;
    notifyListeners();
    try {
      myTrips = await _tripService.getUserTrips();
    } catch (e) {
      debugPrint("Error fetching trips: $e");
    } finally {
      isLoadingTrips = false;
      notifyListeners();
    }
  }

  Future<void> generatePlan({
    required String tripName,
    required String tripDate,
    required int stopCount,
    required List<String> favorites,
    required String preference,
  }) async {
    isGeneratingPlan = true;
    routePreference = preference;
    notifyListeners();
    try {
      generatedStops = await _tripService.generateTripPlan(
        tripName: tripName,
        tripDate: tripDate,
        stopCount: stopCount,
        favorites:
            favorites, // Route preference is intentionally excluded per the backend API
      );
    } catch (e) {
      debugPrint("Error generating plan: $e");
      throw Exception("Failed to generate trip plan: $e");
    } finally {
      isGeneratingPlan = false;
      notifyListeners();
    }
  }

  Future<void> saveGeneratedTrip(
    String tripName,
    String tripDate,
    int stopCount,
    List<String> favorites,
  ) async {
    try {
      final trip = TripModel(
        tripName: tripName,
        tripDate: tripDate,
        stopCount: stopCount,
        status: "Upcoming",
        favorites: favorites,
        stops: generatedStops,
      );
      final newTrip = await _tripService.saveUserTrip(trip);
      myTrips.insert(0, newTrip);
      generatedStops.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Error saving trip to database: $e");
      throw e;
    }
  }

  Future<void> applyAlgorithm(String newPreference) async {
    routePreference = newPreference;
    isGeneratingPlan = true;
    notifyListeners();
    try {
      generatedStops = await _tripService.reorderRouteList(
        generatedStops,
        routePreference,
      );
    } catch (e) {
      debugPrint("Error reordering: $e");
    } finally {
      isGeneratingPlan = false;
      notifyListeners();
    }
  }

  Future<void> updateTripStatus(TripModel trip, String newStatus) async {
    if (trip.id == null) return;
    try {
      await _tripService.updateUserTrip(trip.id!, {'status': newStatus});
      int index = myTrips.indexWhere((t) => t.id == trip.id);
      if (index != -1) {
        myTrips[index] = TripModel(
          id: trip.id,
          tripName: trip.tripName,
          tripDate: trip.tripDate,
          stopCount: trip.stopCount,
          status: newStatus,
          favorites: trip.favorites,
          stops: trip.stops,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }
}
