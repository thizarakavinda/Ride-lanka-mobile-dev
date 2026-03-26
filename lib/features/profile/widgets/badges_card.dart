import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/models/quest_model.dart';

class BadgesCard extends StatelessWidget {
  final List<QuestModel> badges;
  final VoidCallback onTap;

  const BadgesCard({super.key, required this.badges, required this.onTap});

  Widget _buildBadge(QuestModel quest, double size) {
    final image = quest.imageUrl;

    return Tooltip(
      message: quest.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.searchBoxBorder),
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
                  : Text(image, style: TextStyle(fontSize: size * 0.5)),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size,
            child: Text(
              quest.title,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: badges.isEmpty
            ? Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.grey.shade400,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Complete quests to earn badges!',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              )
            : Wrap(
                spacing: 12,
                runSpacing: 12,
                children: badges.map((q) => _buildBadge(q, 56)).toList(),
              ),
      ),
    );
  }
}
