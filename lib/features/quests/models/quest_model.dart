enum QuestStatus { achieved, toBeAchieved, failed }

class QuestModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String reward;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.reward,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Unknown Quest',
      description: json['description'] ?? '',
      imageUrl: json['badgeImage'] ?? '',
      date: json['created_at']?.split('T')?[0] ?? 'Current',
      reward: json['reward']?.toString() ?? 'XP',
    );
  }
}
