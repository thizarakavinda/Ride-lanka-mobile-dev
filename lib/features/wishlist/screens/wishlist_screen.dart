import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/core/utils/wishlist_store.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/home/widgets/popular_place_card.dart';
import 'package:ride_lanka/features/wishlist/widgets/category_filter_row.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final _favoritePlaces = homeProvider.popularPlaces
        .where((place) => FavoritesStore.isFavorite(place.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wishlist',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              CustomSearchBar(searchBoxHint: 'Search Wishlist'),
              const SizedBox(height: 20),
              const CategoryFilterRow(),
              const SizedBox(height: 20),
              if (homeProvider.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_favoritePlaces.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 60,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No wishlist yet',
                          style: TextStyle(color: AppColors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _favoritePlaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return PopularPlaceCard(
                      isWishlist: true,
                      place: _favoritePlaces[index],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
