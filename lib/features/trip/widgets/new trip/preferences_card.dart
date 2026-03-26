import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/widgets/shared/section_card.dart';
import 'package:ride_lanka/features/trip/widgets/shared/section_label.dart';

class PreferencesCard extends StatelessWidget {
  final List<String> selectedFavorites;
  final ValueChanged<String> onToggle;

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Activities',
      'options': [
        {'id': 'hiking', 'label': '🥾 Hiking'},
        {'id': 'dance', 'label': '💃 Dancing'},
        {'id': 'surfing', 'label': '🏄 Surfing'},
        {'id': 'safari', 'label': '🦁 Safari'},
      ],
    },
    {
      'title': 'Themes',
      'options': [
        {'id': 'culture', 'label': '🏛️ Culture'},
        {'id': 'nature', 'label': '🌿 Nature'},
        {'id': 'food', 'label': '🍜 Food'},
        {'id': 'relaxation', 'label': '🧘 Relax'},
      ],
    },
  ];

  const PreferencesCard({
    super.key,
    required this.selectedFavorites,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(
              label: 'Favorites & Preferences', icon: Icons.favorite_border),
          const SizedBox(height: 4),
          const Text(
            'Choose what you enjoy to personalise your route',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ...categories.map((cat) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat['title'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (cat['options'] as List).map((opt) {
                    final isSelected = selectedFavorites.contains(opt['id']);
                    return GestureDetector(
                      onTap: () => onToggle(opt['id']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.lowPrimaryColor
                              : AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          opt['label'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}