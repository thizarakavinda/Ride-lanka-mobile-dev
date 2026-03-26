import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/badges/models/badge_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({super.key, required this.badge});

  Color get _levelColor {
    switch (badge.badgeType.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFF9E9E9E);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return Colors.teal;
    }
  }

  IconData get _levelIcon {
    switch (badge.badgeType.toLowerCase()) {
      case 'gold':
        return Icons.workspace_premium_rounded;
      case 'silver':
        return Icons.military_tech_rounded;
      case 'bronze':
        return Icons.shield_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  Widget _buildBadgeImage(double size) {
    final image = badge.imageUrl;

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
        border: Border.all(color: _levelColor.withOpacity(0.4), width: 2),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double avatarSize = (screenWidth * 0.22).clamp(70.0, 100.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _levelColor.withOpacity(0.3), width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _levelColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dividerText,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _levelColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _levelColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_levelIcon, size: 12, color: _levelColor),
                          const SizedBox(width: 4),
                          Text(
                            badge.badgeType.isEmpty
                                ? 'Badge'
                                : badge.badgeType[0].toUpperCase() +
                                      badge.badgeType.substring(1),
                            style: TextStyle(
                              fontSize: 11,
                              color: _levelColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    if (badge.earnedDate.isNotEmpty) ...[
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badge.earnedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          _buildBadgeImage(avatarSize),
        ],
      ),
    );
  }
}
