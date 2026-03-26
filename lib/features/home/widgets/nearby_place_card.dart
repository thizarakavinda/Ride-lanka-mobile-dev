import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/home/models/nearby_place_model.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class NearbyPlaceCard extends StatelessWidget {
  final NearbyPlaceModel place;

  const NearbyPlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.placeDetails,
          arguments: {'place': place},
        );
      },

      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                place.imageUrl,
                height: 350,
                width: 220,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 350,
                      width: 220,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/imgplaceholder.jpg',
                    height: 350,
                    width: 220,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  context.read<WishlistProvider>().toggleFavorite(place.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          context.read<WishlistProvider>().isFavorite(place.id)
                          ? Text('${place.title} added to wishlist')
                          : Text('${place.title} removed from wishlist'),
                      backgroundColor: AppColors.lowPrimaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Consumer<WishlistProvider>(
                    builder: (context, provider, child) {
                      final isFav = provider.isFavorite(place.id);
                      return Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? AppColors.favoriteColor
                            : AppColors.white,
                      );
                    },
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white.withOpacity(0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          place.category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              place.distance,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text("${place.rating} (${place.reviewsCount})"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
