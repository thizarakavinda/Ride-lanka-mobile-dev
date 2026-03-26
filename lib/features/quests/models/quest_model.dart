enum QuestStatus { achieved, toBeAchieved, failed }

class QuestModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String reward;
  final String category;
  final String difficulty;
  final String type;
  final String level;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.reward,
    required this.category,
    required this.difficulty,
    required this.type,
    required this.level,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Quest',
      description: json['description']?.toString() ?? '',
      imageUrl: json['badgeImage']?.toString() ?? '',
      date: json['createdAt']?.toString().split('T').first ?? '',
      reward: json['reward']?.toString() ?? 'XP',
      category: json['category']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
    );
  }
}
