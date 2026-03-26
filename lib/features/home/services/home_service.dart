import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_lanka/core/services/api_client.dart';

import 'package:ride_lanka/features/home/models/explore_place_model.dart';

class HomeService {
  Future<List<QueryDocumentSnapshot>> fetchPlaces() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('places')
        .get();
    return snapshot.docs;
  }

  Future<List<ExplorePlaceModel>> fetchExplorePlaces() async {
    final response = await ApiClient.get('/api/explore');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> places = data['places'] ?? [];
      return places
          .map((p) => ExplorePlaceModel.fromMap(p['id'] ?? '', p))
          .toList();
    }
    throw Exception('Failed to load explore places: ${response.statusCode}');
  }

  Future<List<ExplorePlaceModel>> searchExplorePlaces(String query) async {
    if (query.trim().isEmpty) return [];
    final all = await fetchExplorePlaces();
    final lowerQuery = query.toLowerCase();
    return all
        .where(
          (p) =>
              p.title.toLowerCase().contains(lowerQuery) ||
              p.snippet.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  Future<List<ExplorePlaceModel>> fetchExplorePlacesByCategory(
    String category,
  ) async {
    final all = await fetchExplorePlaces();
    final lowerCategory = category.toLowerCase();

    const Map<String, List<String>> categoryKeywords = {
      'beach': ['beach', 'coast', 'shore', 'surf', 'bay', 'lagoon'],
      'mountain': [
        'mountain',
        'peak',
        'rock',
        'hill',
        'ella',
        'adams',
        'knuckles',
      ],
      'culture': [
        'temple',
        'fort',
        'ancient',
        'relic',
        'culture',
        'cultural',
        'heritage',
        'stupa',
        'sacred',
        'buddhist',
        'hindu',
        'mosque',
      ],
      'waterfall': ['waterfall', 'falls', 'cascade'],
      'wildlife': [
        'wildlife',
        'safari',
        'leopard',
        'elephant',
        'national park',
        'bird',
        'nature reserve',
      ],
    };

    final keywords = categoryKeywords[lowerCategory] ?? [lowerCategory];

    return all.where((p) {
      final text = '${p.title} ${p.snippet} ${p.content}'.toLowerCase();
      return keywords.any((kw) => text.contains(kw));
    }).toList();
  }
}
