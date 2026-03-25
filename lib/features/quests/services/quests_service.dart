import 'dart:convert';
import 'package:ride_lanka/core/services/api_client.dart';
import 'package:ride_lanka/features/quests/models/quest_model.dart';

class QuestService {
  static Future<List<QuestModel>> getQuests() async {
    final response = await ApiClient.get('/api/quests');
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['quests'] as List;
      return jsonList.map((e) => QuestModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load quests');
    }
  }

  static Future<List<String>> getUserCompletedQuests() async {
    final response = await ApiClient.get('/api/users/profile');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completed = data['completedQuests'] as List? ?? [];
      return completed.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<Map<String, dynamic>> completeQuest(String questId) async {
    final response = await ApiClient.post('/api/quests/$questId/complete', {});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete quest');
    }
  }
}
