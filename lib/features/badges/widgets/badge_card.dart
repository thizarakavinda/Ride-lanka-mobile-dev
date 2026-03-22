import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/badges/models/badge_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({super.key, required this.badge});

  String get _badgeIcon {
    switch (badge.badgeType) {
      case 'gold':
        return AppAssets.platinumIcon;
      case 'bronze':
        return AppAssets.bronzeIcon;
      default:
        return AppAssets.silverIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double avatarRadius = (screenWidth * 0.11).clamp(35.0, 50.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.searchBoxBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dividerText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(_badgeIcon, width: 16, height: 22),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.calendar_today,
                      size: 17,
                      color: AppColors.dividerText,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      badge.earnedDate,
                      style: const TextStyle(
                        color: AppColors.dividerText,
                        fontSize: 14,
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
            backgroundImage: NetworkImage(badge.imageUrl),
          ),
        ],
      ),
    );
  }
}
