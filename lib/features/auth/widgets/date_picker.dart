import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class DatePicker extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool enabled;

  const DatePicker({
    super.key,
    this.controller,
    this.labelText = 'Date of Birth',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: AppColors.dividerText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          readOnly: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$labelText is required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonBorder, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonBorder, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: Icon(Icons.event, color: AppColors.grey),
          ),
          onTap: () async {
            final today = DateTime.now();
            final lastDate = DateTime(today.year, today.month, today.day);

            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: lastDate,
              firstDate: DateTime(1900),
              lastDate: lastDate,
            );

            if (picked != null) {
              controller?.text =
                  '${picked.day.toString().padLeft(2, '0')}/'
                  '${picked.month.toString().padLeft(2, '0')}/'
                  '${picked.year}';
            }
          },
        ),
      ],
    );
  }
}
