import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/home/models/popular_place_model.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/features/home/widgets/popular_place_card.dart';
import 'package:ride_lanka/features/wishlist/widgets/category_filter_row.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _selectedCategory = 'All';

  bool _matchesCategory(String text, String category) {
    if (category == 'All') return true;
    final lowerCategory = category.toLowerCase();
    const Map<String, List<String>> categoryKeywords = {
      'beach': ['beach', 'coast', 'shore', 'surf', 'bay', 'lagoon'],
      'mountain': [
        'mountain',
        'peak',
        'rock',
        'hill',
        'ella',
        'adams',
        'knuckles',
      ],
      'culture': [
        'temple',
        'fort',
        'ancient',
        'relic',
        'culture',
        'cultural',
        'heritage',
        'stupa',
        'sacred',
        'buddhist',
        'hindu',
        'mosque',
      ],
      'waterfall': ['waterfall', 'falls', 'cascade'],
      'wildlife': [
        'wildlife',
        'safari',
        'leopard',
        'elephant',
        'national park',
        'bird',
        'nature reserve',
      ],
    };
    final keywords = categoryKeywords[lowerCategory] ?? [lowerCategory];
    return keywords.any((kw) => text.toLowerCase().contains(kw));
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    // Popular favorites
    final favoritePopulars = homeProvider.popularPlaces
        .where((place) => wishlistProvider.isFavorite(place.id))
        .where(
          (place) =>
              _selectedCategory == 'All' || place.category == _selectedCategory,
        )
        .toList();

    // Nearby favorites
    final favoriteNearbys = homeProvider.nearbyPlaces
        .where((place) => wishlistProvider.isFavorite(place.id))
        .where(
          (place) =>
              _selectedCategory == 'All' || place.category == _selectedCategory,
        )
        .map(
          (n) => PopularPlaceModel(
            id: n.id,
            title: n.title,
            category: n.category,
            distance: n.distance,
            rating: n.rating,
            reviews: n.reviewsCount,
            location: n.location,
            imageUrl: n.imageUrl,
            description: n.description,
          ),
        )
        .toList();

    // Explore (Search) favorites
    final favoriteExplores = homeProvider.allExplorePlaces
        .where((place) => wishlistProvider.isFavorite(place.id))
        .where((place) {
          final text = '${place.title} ${place.snippet} ${place.content}'
              .toLowerCase();
          return _matchesCategory(text, _selectedCategory);
        })
        .map(
          (e) => PopularPlaceModel(
            id: e.id,
            title: e.title,
            category: _selectedCategory == 'All'
                ? 'Destination'
                : _selectedCategory,
            distance: '--',
            rating: 4.8,
            reviews: 125,
            location: 'Sri Lanka',
            imageUrl: e.imageUrl,
            description: e.snippet,
          ),
        )
        .toList();

    // Deduplicate by ID
    final combinedFavorites = [
      ...favoritePopulars,
      ...favoriteNearbys,
      ...favoriteExplores,
    ];
    final uniqueFavoritesMap = <String, PopularPlaceModel>{};
    for (var p in combinedFavorites) {
      uniqueFavoritesMap[p.id] = p;
    }
    final displayList = uniqueFavoritesMap.values.toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: const Text(
                  'Wishlist',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              CustomSearchBar(searchBoxHint: 'Search Wishlist'),
              const SizedBox(height: 20),
              CategoryFilterRow(
                selectedCategory: _selectedCategory,
                onCategoryChanged: (cat) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (homeProvider.isLoading || wishlistProvider.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lowPrimaryColor,
                    ),
                  ),
                )
              else if (displayList.isEmpty)
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
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return PopularPlaceCard(
                        isWishlist: true,
                        place: displayList[index],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
