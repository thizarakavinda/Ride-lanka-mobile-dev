import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class ProfileSummaryButton extends StatelessWidget {
  final IconData icon;
  final String value;
  final String type;
  final VoidCallback onTap;
  const ProfileSummaryButton({
    super.key,
    required this.icon,
    required this.value,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = (MediaQuery.of(context).size.width * 0.07).clamp(
      22.0,
      35.0,
    );

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: AppColors.lowPrimaryColor,
            radius: radius,
            child: Icon(icon, color: AppColors.white, size: radius * 0.75),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Text(
          type,
          style: const TextStyle(
            color: AppColors.dividerText,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
