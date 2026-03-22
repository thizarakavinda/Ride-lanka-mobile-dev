import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class SettingCard extends StatelessWidget {
  final String settingTitle;
  final VoidCallback onTap;

  const SettingCard({
    super.key,
    required this.settingTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.searchBoxBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settingTitle,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
