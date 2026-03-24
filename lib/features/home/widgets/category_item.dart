import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radius = size.width * 0.07;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: radius,
            // Highlighted when selected, default teal otherwise
            backgroundColor: isSelected
                ? const Color(0xFF2A7A8C)
                : const Color(0xFF5BA3B2),
            child: SvgPicture.asset(
              icon,
              width: radius * 0.85,
              height: radius * 0.85,
              // Slightly brighter icon when selected
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: size.width * 0.030,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'Helvetica1',
              color: isSelected ? const Color(0xFF2A7A8C) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
