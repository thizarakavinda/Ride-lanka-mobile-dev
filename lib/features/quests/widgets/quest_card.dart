import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/models/quest_model.dart';
import 'package:ride_lanka/features/quests/providers/quests_provider.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;
  final QuestStatus status;

  const QuestCard({super.key, required this.quest, required this.status});

  Color get _statusColor {
    switch (status) {
      case QuestStatus.achieved:
        return Colors.green;
      case QuestStatus.toBeAchieved:
        return Colors.orange;
      case QuestStatus.failed:
        return Colors.red;
    }
  }

  String get _statusLabel {
    switch (status) {
      case QuestStatus.achieved:
        return 'Achieved';
      case QuestStatus.toBeAchieved:
        return 'To be Achieved';
      case QuestStatus.failed:
        return 'Failed to Obtain';
    }
  }

  Widget get _statusIcon {
    switch (status) {
      case QuestStatus.achieved:
        return const Icon(Icons.check_circle, color: Colors.green, size: 18);
      case QuestStatus.toBeAchieved:
        return const Icon(Icons.help, color: Colors.orange, size: 18);
      case QuestStatus.failed:
        return const Icon(Icons.cancel, color: Colors.red, size: 18);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final double avatarRadius = (sw * 0.11).clamp(30.0, 45.0);
    final double titleSize = (sw * 0.042).clamp(14.0, 17.0);
    final double bodySize = (sw * 0.033).clamp(11.0, 14.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.searchBoxBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        quest.title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quest.reward,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  quest.description,
                  style: TextStyle(
                    fontSize: bodySize,
                    color: AppColors.dividerText,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _statusIcon,
                        const SizedBox(width: 5),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            fontSize: bodySize,
                            fontWeight: FontWeight.w500,
                            color: _statusColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (status != QuestStatus.achieved)
                      Consumer<QuestProvider>(
                        builder: (context, provider, child) {
                          bool isCompletingMe =
                              provider.completingId == quest.id;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              minimumSize: const Size(60, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: isCompletingMe
                                ? null
                                : () =>
                                      provider.completeSelectedQuest(quest.id),
                            child: isCompletingMe
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Complete',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (quest.imageUrl.isNotEmpty)
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: NetworkImage(quest.imageUrl),
              backgroundColor: Colors.grey.shade100,
            ),
        ],
      ),
    );
  }
}
