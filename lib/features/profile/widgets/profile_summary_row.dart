import 'package:flutter/material.dart';
import 'package:ride_lanka/features/profile/widgets/profile_summary.dart';

class ProfileSummaryRow extends StatelessWidget {
  const ProfileSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileSummaryButton(
          icon: Icons.location_on,
          value: '1',
          type: 'Trips',
          onTap: () {},
        ),
        ProfileSummaryButton(
          icon: Icons.favorite,
          value: '12',
          type: 'Favorites',
          onTap: () {},
        ),
        ProfileSummaryButton(
          icon: Icons.eco_sharp,
          value: '~ 7.4 kg',
          type: 'CO₂ saved',
          onTap: () {},
        ),
      ],
    );
  }
}
