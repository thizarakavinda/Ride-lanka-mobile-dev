import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class CategoryFilterRow extends StatefulWidget {
  const CategoryFilterRow({super.key});

  @override
  State<CategoryFilterRow> createState() => _CategoryFilterRowState();
}

class _CategoryFilterRowState extends State<CategoryFilterRow> {
  final List<String> _categories = [
    'All',
    'Mountain',
    'Beach',
    'Culture',
    'Wildlife',
    'Waterfall',
  ];
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // _FilterButton(),
        const SizedBox(width: 8),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selected == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = category),
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
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
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
          ),
        ),
      ],
    );
  }
}

// class _FilterButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // open filter bottom sheet later
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.grey.withOpacity(0.4)),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.tune, size: 18, color: AppColors.grey),
//             const SizedBox(width: 4),
//             Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
