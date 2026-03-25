import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:shimmer/shimmer.dart';

class PlaceDetailsInfoCard extends StatelessWidget {
  final String id;
  final String category;
  final String title;
  final String location;
  final String distance;
  final double rating;
  final int reviewsCount;
  final String description;
  final String? mapUrl;
  final bool isLoadingMap;

  const PlaceDetailsInfoCard({
    super.key,
    required this.id,
    required this.category,
    required this.title,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    this.mapUrl,
    required this.isLoadingMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Top row: Category & Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5BAAB9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Consumer<WishlistProvider>(
                      builder: (context, provider, child) {
                        final isFav = provider.isFavorite(id);
                        return GestureDetector(
                          onTap: () => context.read<WishlistProvider>().toggleFavorite(id),
                          child: _buildActionButton(isFav ? Icons.favorite : Icons.favorite_border, isFav ? Colors.red : null),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(Icons.ios_share),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: _buildActionButton(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),

            // Location & Distance
            Row(
              children: [
                Text(
                  '$category in $location',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.near_me,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviewsCount)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '5:30 AM - 8:00 PM',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description text
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Location Header
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),

            // Map View container
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isLoadingMap
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      )
                    : Image.network(
                        mapUrl ??
                            'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/imgplaceholder.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, [Color? color]) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6), // light grey exactly like design
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color ?? (icon == Icons.favorite
            ? Colors.grey.shade400
            : Colors.grey.shade700),
        size: 20,
      ), // Favorite icon is grey in design until filled
    );
  }
}
