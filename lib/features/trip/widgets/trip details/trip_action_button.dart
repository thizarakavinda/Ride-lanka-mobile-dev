import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/trip/screens/trip_starter_screen.dart';

class TripActionButton extends StatelessWidget {
  final TripModel trip;
  const TripActionButton({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, provider, _) {
        final isActive = trip.status == 'Active';
        final isCompleted = trip.status == 'Completed';

        if (isCompleted) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.blueGrey, size: 18),
                SizedBox(width: 8),
                Text(
                  'Trip Completed',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isActive ? Colors.green : AppColors.lowPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            icon: Icon(
              isActive ? Icons.flag : Icons.directions_car,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              isActive ? 'Mark as Completed' : 'Start Trip',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            onPressed: () {
              if (isActive) {
                provider.updateTripStatus(trip, 'Completed');
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TripStarterScreen(trip: trip),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}