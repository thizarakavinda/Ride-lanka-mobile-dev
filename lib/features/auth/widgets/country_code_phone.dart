import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class CountryCodePhone extends StatelessWidget {
  const CountryCodePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            color: AppColors.dividerText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          decoration: InputDecoration(
            hintText: 'Phone Number',
            // 1. Normal State
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonBorder, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonBorder, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            // 2. Error State
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.errorBorder,
                width: 1.5,
              ), // Matches enabledBorder
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.errorBorder,
                width: 2,
              ), // Matches focusedBorder
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          initialCountryCode: 'LK',

          onChanged: (phone) {},
        ),
      ],
    );
  }
}
