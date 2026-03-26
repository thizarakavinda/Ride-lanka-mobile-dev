import 'dart:convert';
import 'package:ride_lanka/core/services/api_client.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';

class TripService {
  Future<List<TripModel>> getUserTrips() async {
    final response = await ApiClient.get('/api/users/trips');

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['trips'] as List;
      return jsonList.map((e) => TripModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<List<StopModel>> generateTripPlan({
    required String tripName,
    required String tripDate,
    required int stopCount,
    required List<String> favorites,
  }) async {
    final response = await ApiClient.post('/api/users/trips/plan', {
      'trip_name': tripName,
      'trip_date': tripDate,
      'stop_count': stopCount,
      'favorites': favorites,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final stopsList = data['stops'] as List? ?? [];
      return stopsList.map((e) => StopModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to generate trip plan');
    }
  }

  Future<List<StopModel>> reorderRouteList(
    List<StopModel> stops,
    String preference,
  ) async {
    final response = await ApiClient.post('/api/users/trips/reorder', {
      'stops': stops.map((s) => s.toJson()).toList(),
      'preference': preference,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newStops = data['stops'] as List? ?? [];
      return newStops.map((e) => StopModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to reorder route');
    }
  }

  Future<TripModel> saveUserTrip(TripModel trip) async {
    final response = await ApiClient.post('/api/users/trips', trip.toJson());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TripModel.fromJson(data);
    } else {
      throw Exception('Failed to save trip');
    }
  }

  Future<void> updateUserTrip(
    String tripId,
    Map<String, dynamic> updateData,
  ) async {
    final response = await ApiClient.put(
      '/api/users/trips/$tripId',
      updateData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update trip');
    }
  }
}
