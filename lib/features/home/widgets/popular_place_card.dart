import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/features/home/models/popular_place_model.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class PopularPlaceCard extends StatefulWidget {
  final PopularPlaceModel place;
  final bool? isWishlist;
  const PopularPlaceCard({
    super.key,
    required this.place,
    this.isWishlist = false,
  });

  @override
  State<PopularPlaceCard> createState() => _PopularPlaceCardState();
}

class _PopularPlaceCardState extends State<PopularPlaceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.placeDetails,
          arguments: {'place': widget.place},
        );
      },
      child: Card(
        color: AppColors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.place.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/imgplaceholder.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.place.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            if (widget.isWishlist == true)
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      AppColors.bottomNavBackground,
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                context.read<WishlistProvider>().toggleFavorite(
                                  widget.place.id,
                                );
                              },
                              child: Consumer<WishlistProvider>(
                                builder: (context, provider, child) {
                                  final isFav = provider.isFavorite(
                                    widget.place.id,
                                  );
                                  return Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : AppColors.grey,
                                    size: 20,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.currentLocationText,
                          size: 14,
                        ),
                        Text(
                          " ${widget.place.rating} (${widget.place.reviews})   ",
                        ),
                        const Icon(
                          CupertinoIcons.location_fill,
                          size: 14,
                          color: AppColors.grey,
                        ),
                        Text(" ${widget.place.distance}"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.grey,
                          size: 14,
                        ),
                        Text(
                          widget.place.location,
                          style: const TextStyle(
                            color: AppColors.dividerText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
