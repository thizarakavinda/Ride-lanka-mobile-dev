import 'package:flutter/material.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/widgets/shared/info_chip.dart';
import 'package:ride_lanka/features/trip/widgets/shared/status_badge.dart';

class TripInfoHeader extends StatelessWidget {
  final TripModel trip;
  const TripInfoHeader({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          InfoChip(icon: Icons.calendar_today, label: trip.tripDate),
          const SizedBox(width: 10),
          InfoChip(icon: Icons.place, label: '${trip.stopCount} Stops'),
          const SizedBox(width: 10),
          StatusBadge(status: trip.status),
        ],
      ),
    );
  }
}