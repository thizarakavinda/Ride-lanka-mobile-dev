import 'package:ride_lanka/features/quests/models/quest_model.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String badgeType;
  final String earnedDate;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badgeType,
    required this.earnedDate,
  });

  factory BadgeModel.fromQuest(QuestModel quest) {
    return BadgeModel(
      id: quest.id,
      title: quest.title,
      description: quest.description,
      imageUrl: quest.imageUrl,
      badgeType: quest.level,
      earnedDate: quest.date,
    );
  }
}
