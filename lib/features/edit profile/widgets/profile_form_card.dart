import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/edit%20profile/widgets/profile_form_field.dart';

class ProfileFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const ProfileFormCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.searchBoxBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileFormField(
            label: 'Full Name',
            icon: Icons.person_rounded,
            controller: nameController,
            hint: 'Enter your full name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          ProfileFormField(
            label: 'Phone Number',
            icon: Icons.phone_rounded,
            controller: phoneController,
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
