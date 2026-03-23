import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    (sw * 0.05).clamp(16.0, 28.0);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
            children: [CustomSearchBar(searchBoxHint: 'Search trip...')],
          ),
        ),
      ),
    );
  }
}
