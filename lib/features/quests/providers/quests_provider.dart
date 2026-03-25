import 'package:flutter/foundation.dart';
import 'package:ride_lanka/features/quests/models/quest_model.dart';
import 'package:ride_lanka/features/quests/services/quests_service.dart';

class QuestProvider extends ChangeNotifier {
  List<QuestModel> allQuests = [];
  List<String> completedQuestIds = [];
  bool isLoading = false;
  String? completingId;

  Future<void> fetchQuestsData() async {
    isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        QuestService.getQuests(),
        QuestService.getUserCompletedQuests(),
      ]);

      allQuests = results[0] as List<QuestModel>;
      completedQuestIds = results[1] as List<String>;
    } catch (e) {
      debugPrint("Error fetching quests: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeSelectedQuest(String questId) async {
    completingId = questId;
    notifyListeners();
    try {
      final res = await QuestService.completeQuest(questId);
      completedQuestIds.add(questId);
      debugPrint("Quest Completed! You gained ${res['xpGained']} XP.");
    } catch (e) {
      debugPrint("Completion Error: $e");
      throw Exception('Failed to claim reward');
    } finally {
      completingId = null;
      notifyListeners();
    }
  }

  QuestStatus getStatusForQuest(String questId) {
    if (completedQuestIds.contains(questId)) return QuestStatus.achieved;
    return QuestStatus.toBeAchieved;
  }
}
