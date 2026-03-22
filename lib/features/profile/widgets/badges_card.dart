import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/badges/data/badge_data.dart';

class BadgesCard extends StatelessWidget {
  final String? badgeImageUrl;
  final VoidCallback onTap;
  const BadgesCard({super.key, required this.onTap, this.badgeImageUrl});

  @override
  Widget build(BuildContext context) {
    final badges = BadgeData.badges;
    final double cardHeight = (MediaQuery.of(context).size.height * 0.13).clamp(
      90.0,
      130.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: cardHeight,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.searchBoxBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: cardHeight * 0.4,
                backgroundImage: NetworkImage(badges[index].imageUrl),
              ),
            );
          },
        ),
      ),
    );
  }
}
