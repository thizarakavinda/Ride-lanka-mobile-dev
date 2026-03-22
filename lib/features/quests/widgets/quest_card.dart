import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/models/quest_model.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;

  const QuestCard({super.key, required this.quest});

  Color get _statusColor {
    switch (quest.status) {
      case QuestStatus.achieved:
        return Colors.green;
      case QuestStatus.toBeAchieved:
        return Colors.orange;
      case QuestStatus.failed:
        return Colors.red;
    }
  }

  String get _statusLabel {
    switch (quest.status) {
      case QuestStatus.achieved:
        return 'Achieved';
      case QuestStatus.toBeAchieved:
        return 'To be Achieved';
      case QuestStatus.failed:
        return 'Failed to Obtain';
    }
  }

  Widget get _statusIcon {
    switch (quest.status) {
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
    final double avatarRadius = (sw * 0.11).clamp(35.0, 50.0);
    final double titleSize = (sw * 0.042).clamp(14.0, 18.0);
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
                Text(
                  quest.title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
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
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: bodySize + 2,
                      color: AppColors.dividerText,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      quest.date,
                      style: TextStyle(
                        fontSize: bodySize,
                        color: AppColors.dividerText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _statusIcon,
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: bodySize,
                          fontWeight: FontWeight.w500,
                          color: _statusColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: NetworkImage(quest.imageUrl),
          ),
        ],
      ),
    );
  }
}
