import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Row(
      children: [
        _StatCard(
          icon: Icons.map_rounded,
          value: tripProvider.myTrips.length.toString(),
          label: 'Trips',
          color: AppColors.primaryColor,
          onTap: () => Navigator.pushNamed(context, AppRoutes.tripHistory),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.favorite_rounded,
          value: wishlistProvider.favoriteIds.length.toString(),
          label: 'Favorites',
          color: Colors.redAccent,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.eco_rounded,
          value: '0kg',
          label: 'CO₂ Saved',
          color: Colors.green,
          onTap: () {},
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(5, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.dividerText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
