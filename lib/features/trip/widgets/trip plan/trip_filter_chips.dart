import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class TripFilterChips extends StatelessWidget {
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterChanged;

  const TripFilterChips({
    super.key,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryColor : AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 90, 90, 90),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
