import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';

import 'package:url_launcher/url_launcher.dart'; // Add url_launcher to pubspec.yaml if not present!

class TripDetailsScreen extends StatelessWidget {
  final TripModel trip;

  TripDetailsScreen({required this.trip});

  Future<void> _launchMapsForStop(StopModel stop) async {
    // If you have lat/lng in your StopModel, launch direct URI bounds. For now we use the query name!
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(stop.name)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.tripName)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.teal.shade50,
            child: Column(
              children: [
                Text(
                  'Trip Status: ${trip.status}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Toggle Active / Completed
                    String newStatus = trip.status == "Upcoming"
                        ? "Active"
                        : (trip.status == "Active" ? "Completed" : "Active");
                    Provider.of<TripProvider>(
                      context,
                      listen: false,
                    ).updateTripStatus(trip, newStatus);
                    Navigator.pop(context); // Go back after changing
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: trip.status == "Active"
                        ? Colors.green
                        : Colors.teal,
                  ),
                  child: Text(
                    trip.status == "Active"
                        ? 'Mark as Completed'
                        : 'Start Driving / Active',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: trip.stops.length,
              itemBuilder: (context, index) {
                final stop = trip.stops[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${stop.stopOrder}. ${stop.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.map, color: Colors.teal),
                              onPressed: () => _launchMapsForStop(stop),
                              tooltip: "Open in Maps",
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          stop.description,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        if (stop.stopNote != null) ...[
                          SizedBox(height: 8),
                          Text(
                            '💡 ${stop.stopNote}',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
