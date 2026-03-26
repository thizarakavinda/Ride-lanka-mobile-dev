import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color _statusColor() {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Completed':
        return Colors.blueGrey;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _statusIcon() {
    switch (status) {
      case 'Active':
        return Icons.directions_car;
      case 'Completed':
        return Icons.check_circle_outline;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(), size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
