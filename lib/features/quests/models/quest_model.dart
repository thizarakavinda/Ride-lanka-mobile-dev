enum QuestStatus { achieved, toBeAchieved, failed }

class QuestModel {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final QuestStatus status;

  const QuestModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.status,
  });
}