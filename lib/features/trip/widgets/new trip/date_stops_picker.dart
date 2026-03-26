import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/widgets/shared/section_card.dart';
import 'package:ride_lanka/features/trip/widgets/shared/section_label.dart';

class DateStopsPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final int stopCount;
  final ValueChanged<DateTime> onDatePicked;
  final ValueChanged<int> onStopCountChanged;

  const DateStopsPicker({
    super.key,
    required this.selectedDate,
    required this.stopCount,
    required this.onDatePicked,
    required this.onStopCountChanged,
  });

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          // Date picker
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(label: 'Date', icon: Icons.calendar_today),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) onDatePicked(picked);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.bottomNavBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 16, color: AppColors.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate == null
                              ? 'Pick a date'
                              : _formatDate(selectedDate!),
                          style: TextStyle(
                            fontSize: 13,
                            color: selectedDate == null
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Stops dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(label: 'Stops', icon: Icons.place),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bottomNavBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: stopCount,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor),
                      items: List.generate(
                        20,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1} Stop${i == 0 ? '' : 's'}',
                              style: const TextStyle(fontSize: 13)),
                        ),
                      ),
                      onChanged: (val) => onStopCountChanged(val!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}