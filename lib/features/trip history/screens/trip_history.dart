import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/trip/models/trip_model.dart';
import 'package:ride_lanka/features/trip/services/trip_service.dart';
import 'package:ride_lanka/features/trip%20history/widgets/trip_card.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  final TripService _tripService = TripService();
  List<TripModel> _allTrips = [];
  List<TripModel> _filteredTrips = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    try {
      final trips = await _tripService.getUserTrips();
      if (mounted) {
        setState(() {
          _allTrips = trips.where((t) => t.status == 'Completed').toList();
          _filteredTrips = _allTrips;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading trips: $e')));
      }
    }
  }

  void _filterTrips(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTrips = _allTrips;
      } else {
        _filteredTrips = _allTrips
            .where(
              (trip) =>
                  trip.tripName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Prevent back button if not needed
        title: Text(
          'Trip History',
          style: TextStyle(
            fontSize: (sw * 0.062).clamp(20.0, 28.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              CustomSearchBar(
                searchBoxHint: 'Search trip...',
                onChanged: _filterTrips,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredTrips.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _filteredTrips.length,
                        itemBuilder: (context, index) {
                          return TripCard(trip: _filteredTrips[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.history : Icons.search_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No completed trips yet'
                : 'No trips matching "$_searchQuery"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Your past adventures will appear here.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }
}
