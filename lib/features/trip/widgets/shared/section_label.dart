import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const SectionLabel({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
