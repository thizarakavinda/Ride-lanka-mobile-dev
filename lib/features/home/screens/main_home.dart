import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/home/models/explore_place_model.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/home/models/category_model.dart';
import 'package:ride_lanka/features/home/widgets/category_item.dart';
import 'package:ride_lanka/features/home/widgets/nearby_place_card.dart';
import 'package:ride_lanka/features/home/widgets/popular_place_card.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

const String helvetica1 = 'Helvetica1';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final List<CategoryModel> categories = [
    CategoryModel(label: 'Beach', icon: AppAssets.beachIcon),
    CategoryModel(label: 'Mountain', icon: AppAssets.mountainIcon),
    CategoryModel(label: 'Culture', icon: AppAssets.cultureIcon),
    CategoryModel(label: 'Waterfall', icon: AppAssets.waterfallIcon),
    CategoryModel(label: 'Wildlife', icon: AppAssets.wildlifeIcon),
  ];

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchHomeData();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hPad = size.width * 0.05;
    final homeProvider = context.watch<HomeProvider>();

    final bool showCategoryResults = homeProvider.selectedCategory != null;
    final bool showSearchResults = homeProvider.searchQuery.isNotEmpty;
    final bool showDefault = !showCategoryResults && !showSearchResults;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bottomNavBackground,
        body: Stack(
          children: [
            // ── Top background design ──────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                AppAssets.homeTopDesign,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),

            // ── Header: greeting + search bar ─────────────────────────────
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${homeProvider.userName}',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: size.width * 0.065,
                                fontFamily: helvetica1,
                              ),
                            ),
                            Text(
                              homeProvider.currentLocationName,
                              style: TextStyle(
                                color: AppColors.currentLocationText,
                                fontSize: size.width * 0.038,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          AppAssets.logo,
                          color: AppColors.black,
                          width: size.width * 0.10,
                          height: size.width * 0.10,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),

                    // ── Search bar ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _searchController,
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce!.cancel();
                                }
                                _debounce = Timer(
                                  const Duration(milliseconds: 500),
                                  () {
                                    homeProvider.searchPlaces(value);
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  left: 10,
                                  top: 13,
                                ),
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search destinations',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (homeProvider.searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                homeProvider.clearSearch();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: AppColors.grey,
                              thickness: 1,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body content ──────────────────────────────────────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.23),

                  // ── Category icons row + All button ────────────────────
                  Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // "All" button — only shown when a category is active
                        if (showCategoryResults)
                          GestureDetector(
                            onTap: () {
                              homeProvider.clearSearch();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: size.width * 0.07,
                                  backgroundColor: const Color(0xFF2A7A8C),
                                  child: Icon(
                                    Icons.grid_view_rounded,
                                    color: Colors.white,
                                    size: size.width * 0.06,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'All',
                                  style: TextStyle(
                                    fontSize: size.width * 0.030,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Helvetica1',
                                    color: const Color(0xFF2A7A8C),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Category items
                        ...categories.map(
                          (cat) => CategoryItem(
                            icon: cat.icon,
                            label: cat.label,
                            isSelected:
                                homeProvider.selectedCategory == cat.label,
                            onTap: () {
                              _searchController.clear();
                              homeProvider.selectCategory(cat.label);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Main scrollable area ───────────────────────────────
                  Expanded(
                    child: homeProvider.isLoading
                        ? _buildHomeShimmer(size, hPad)
                        : RefreshIndicator(
                            onRefresh: () =>
                                homeProvider.fetchHomeData(force: true),
                            color: AppColors.primaryColor,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── SEARCH RESULTS ───────────────────────
                                  if (showSearchResults) ...[
                                    SizedBox(height: size.height * 0.02),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: hPad,
                                      ),
                                      child: Text(
                                        homeProvider.isSearching
                                            ? 'Searching...'
                                            : 'Results for "${homeProvider.searchQuery}"',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 18,
                                          fontFamily: helvetica1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (homeProvider.isSearching)
                                      _buildExploreShimmerList(hPad)
                                    else if (homeProvider.searchResults.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: hPad,
                                          vertical: 20,
                                        ),
                                        child: const Text(
                                          'No places found. Try a different search.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: hPad,
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              homeProvider.searchResults.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 12),
                                          itemBuilder: (context, index) {
                                            return _ExplorePlaceCard(
                                              place: homeProvider
                                                  .searchResults[index],
                                            );
                                          },
                                        ),
                                      ),
                                  ]
                                  // ── CATEGORY RESULTS ─────────────────────
                                  else if (showCategoryResults) ...[
                                    SizedBox(height: size.height * 0.02),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: hPad,
                                      ),
                                      child: Text(
                                        homeProvider.selectedCategory!,
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 18,
                                          fontFamily: helvetica1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (homeProvider.isCategoryLoading)
                                      _buildExploreShimmerList(hPad)
                                    else if (homeProvider
                                        .categoryPlaces
                                        .isEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: hPad,
                                          vertical: 20,
                                        ),
                                        child: const Text(
                                          'No places found for this category.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: hPad,
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: homeProvider
                                              .categoryPlaces
                                              .length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 12),
                                          itemBuilder: (context, index) {
                                            return _ExplorePlaceCard(
                                              place: homeProvider
                                                  .categoryPlaces[index],
                                            );
                                          },
                                        ),
                                      ),
                                  ]
                                  // ── DEFAULT: Nearby + Popular ─────────────
                                  else if (showDefault) ...[
                                    SizedBox(height: size.height * 0.025),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: hPad,
                                      ),
                                      child: Text(
                                        'Nearby',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 20,
                                          fontFamily: helvetica1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: size.height * 0.3,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: hPad,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            homeProvider.nearbyPlaces.length,
                                        itemBuilder: (context, index) {
                                          return NearbyPlaceCard(
                                            place: homeProvider
                                                .nearbyPlaces[index],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.025),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: hPad,
                                      ),
                                      child: Text(
                                        'Popular',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 20,
                                          fontFamily: helvetica1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: hPad,
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            homeProvider.popularPlaces.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          return PopularPlaceCard(
                                            place: homeProvider
                                                .popularPlaces[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: size.height * 0.04),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeShimmer(Size size, double hPad) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 24,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: size.height * 0.3,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 24,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  Widget _buildExploreShimmerList(double hPad) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Explore place card used for both search + category results ─────────────
class _ExplorePlaceCard extends StatelessWidget {
  final ExplorePlaceModel place;

  const _ExplorePlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.placeDetails,
          arguments: {'place': place},
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: place.imageUrl.isNotEmpty
                  ? Image.network(
                      place.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 90,
                            height: 90,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/imgplaceholder.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
