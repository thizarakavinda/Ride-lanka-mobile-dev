import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/badges/data/badge_data.dart';
import 'package:ride_lanka/features/badges/widgets/badge_card.dart';
import 'package:ride_lanka/features/wishlist/widgets/category_filter_row.dart';

class BadgesInfo extends StatelessWidget {
  const BadgesInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = BadgeData.badges;
    

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Badges',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CategoryFilterRow(),

              const SizedBox(height: 20),

              Text(
                '${badges.length} Badges Earned',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.dividerText,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: badges.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return BadgeCard(badge: badges[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
