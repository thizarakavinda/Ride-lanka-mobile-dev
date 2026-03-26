import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/widgets/shared/trip_stop_card.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20details/trip_action_button.dart';
import 'package:ride_lanka/features/trip/widgets/trip%20details/trip_info_header.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final trip = args?['trip'] as TripModel?;

    if (trip == null) {
      return const Scaffold(body: Center(child: Text('No trip found')));
    }

    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          trip.tripName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TripInfoHeader(trip: trip),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: TripActionButton(trip: trip),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: trip.stops.isEmpty
                  ? const Center(
                      child: Text(
                        'No stops found for this trip.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: trip.stops.length,
                      itemBuilder: (context, index) => TripStopCard(
                        stop: trip.stops[index],
                        isLast: index == trip.stops.length - 1,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
