import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:shimmer/shimmer.dart';

class TripListCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const TripListCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  trip.stops.isNotEmpty && trip.stops[0].photoUrl != null
                      ? trip.stops[0].photoUrl!
                      : 'https://images.unsplash.com/photo-1544487661-04e8d38cb71f?w=300&q=80',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 80,
                        width: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/imgplaceholder.jpg',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.tripName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: AppColors.forgotPasswordText,
                        ),
                        Text(
                          ' ${trip.tripDate}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.favoriteColor,
                        ),
                        Text(
                          '${trip.stopCount} stops',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: trip.status == 'Active'
                            ? Colors.green
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        trip.status,
                        style: TextStyle(
                          color: trip.status == 'Active'
                              ? Colors.white
                              : Colors.teal.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
