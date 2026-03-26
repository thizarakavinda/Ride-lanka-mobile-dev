import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/home/models/popular_place_model.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/features/home/widgets/popular_place_card.dart';
import 'package:ride_lanka/features/wishlist/widgets/category_filter_row.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';
import 'package:shimmer/shimmer.dart';

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
        top: true,
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
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(height: 100, width: double.infinity),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([
                      homeProvider.fetchHomeData(force: true),
                      wishlistProvider.loadFavorites(force: true),
                    ]);
                  },
                  color: AppColors.primaryColor,
                  child: displayList.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: const Center(
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
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: displayList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return PopularPlaceCard(
                              isWishlist: true,
                              place: displayList[index],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
