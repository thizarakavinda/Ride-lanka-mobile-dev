import 'package:ride_lanka/features/quests/models/quest_model.dart';

class QuestData {
  static const List<QuestModel> quests = [
    QuestModel(
      title: "Trail to Pidurutalagala's Throne",
      description:
          'The highest mountain in Sri Lanka, standing at 2,524 meters above sea level.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Knuckles_mountain_range.jpg/320px-Knuckles_mountain_range.jpg',
      date: '2025.12.20',
      status: QuestStatus.achieved,
    ),
    QuestModel(
      title: 'Journey to Jungle Beach',
      description:
          'A hidden coastal paradise surrounded by lush jungle and golden sands.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Unawatuna_beach.jpg/320px-Unawatuna_beach.jpg',
      date: '2025.12.20',
      status: QuestStatus.toBeAchieved,
    ),
    QuestModel(
      title: 'Whispers of Ella Rock',
      description:
          'A scenic mountain trail leading through misty forests to a breathtaking summit viewpoint.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Sri_Lanka_Sigiriya_edit.jpg/320px-Sri_Lanka_Sigiriya_edit.jpg',
      date: '2025.12.20',
      status: QuestStatus.failed,
    ),
  ];
}