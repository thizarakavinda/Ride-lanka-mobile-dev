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

  IconData get _statusIconData {
    switch (status) {
      case QuestStatus.achieved:
        return Icons.check_circle_rounded;
      case QuestStatus.toBeAchieved:
        return Icons.radio_button_unchecked_rounded;
      case QuestStatus.failed:
        return Icons.cancel_rounded;
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFF9E9E9E);
      case 'gold':
        return const Color(0xFFFFD700);
      default:
        return Colors.teal;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'adventure':
        return Icons.terrain_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'culture':
        return Icons.museum_rounded;
      case 'nature':
        return Icons.park_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  Widget _buildBadgeImage(double size) {
    final image = quest.imageUrl;
    if (image.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.emoji_events, color: Colors.teal),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.teal.shade100, width: 2),
      ),
      child: Center(
        child: image.startsWith('http')
            ? ClipOval(
                child: Image.network(
                  image,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.emoji_events, color: Colors.teal),
                ),
              )
            : Text(image, style: TextStyle(fontSize: size * 0.45)),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final double titleSize = (sw * 0.042).clamp(14.0, 17.0);
    final double bodySize = (sw * 0.033).clamp(11.0, 14.0);
    final bool isAchieved = status == QuestStatus.achieved;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isAchieved
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isAchieved
                ? Colors.green.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadgeImage(58),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              quest.title,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade400,
                                  Colors.teal.shade700,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bolt_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  quest.reward,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        quest.description,
                        style: TextStyle(
                          fontSize: bodySize,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (quest.category.isNotEmpty)
                  _buildChip(
                    icon: _categoryIcon(quest.category),
                    label:
                        quest.category[0].toUpperCase() +
                        quest.category.substring(1),
                    color: Colors.teal,
                  ),
                if (quest.difficulty.isNotEmpty)
                  _buildChip(
                    icon: Icons.bar_chart_rounded,
                    label:
                        quest.difficulty[0].toUpperCase() +
                        quest.difficulty.substring(1),
                    color: _difficultyColor(quest.difficulty),
                  ),
                if (quest.level.isNotEmpty)
                  _buildChip(
                    icon: Icons.military_tech_rounded,
                    label:
                        quest.level[0].toUpperCase() + quest.level.substring(1),
                    color: _levelColor(quest.level),
                  ),
                if (quest.type.isNotEmpty)
                  _buildChip(
                    icon: Icons.label_rounded,
                    label:
                        quest.type[0].toUpperCase() + quest.type.substring(1),
                    color: Colors.indigo,
                  ),
                if (quest.date.isNotEmpty)
                  _buildChip(
                    icon: Icons.calendar_today_rounded,
                    label: quest.date,
                    color: Colors.grey.shade600,
                  ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIconData, color: _statusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        fontSize: bodySize,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),

                if (!isAchieved)
                  Consumer<QuestProvider>(
                    builder: (context, provider, _) {
                      final bool isCompletingMe =
                          provider.completingId == quest.id;
                      return GestureDetector(
                        onTap: isCompletingMe
                            ? null
                            : () => provider.completeSelectedQuest(quest.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            gradient: isCompletingMe
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.lowPrimaryColor,
                                    ],
                                  ),
                            color: isCompletingMe ? Colors.grey.shade200 : null,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isCompletingMe
                                ? null
                                : [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                          ),
                          child: isCompletingMe
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Complete',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),

                if (isAchieved)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Reward Claimed',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
