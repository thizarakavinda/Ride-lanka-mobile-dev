import 'package:cloud_firestore/cloud_firestore.dart';

class PopularPlaceModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String distance;
  final double rating;
  final int reviews;
  final String imageUrl;
  final bool isFavorite;

  PopularPlaceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory PopularPlaceModel.fromFirestore(
    DocumentSnapshot doc, {
    String calculatedDistance = 'N/A',
  }) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return PopularPlaceModel(
        id: doc.id,
        title: 'Unknown',
        category: 'Destination',
        location: 'Sri Lanka',
        distance: calculatedDistance,
        rating: 4.5,
        reviews: 0,
        imageUrl: '',
      );
    }

    final images = data['images'] as List<dynamic>? ?? [];
    final String imageUrl = images.isNotEmpty
        ? images.first.toString()
        : _fallbackImage(data['category'] as String? ?? '');

    return PopularPlaceModel(
      id: doc.id,
      title: data['name'] ?? 'Unknown',
      category: data['category'] ?? 'Destination',
      location: data['district'] ?? data['province'] ?? 'Sri Lanka',
      distance: calculatedDistance,
      rating: ((data['averageCost'] ?? 4.5) as num).toDouble(),
      reviews: ((data['popularityScore'] ?? 0) as num).toInt(),
      imageUrl: imageUrl,
      isFavorite: false,
    );
  }

  static String _fallbackImage(String category) {
    const Map<String, String> categoryImages = {
      'Religious':
          'https://d3gpg9xwvhoccm.cloudfront.net/2019/03/thuparamya.jpg',
      'Beach':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
      'Wildlife':
          'https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=800&q=80',
      'Culture':
          'https://thesingaporetouristpass.com.sg/wp-content/uploads/2020/09/11.BuddhaToothRelic_1-scaled-1.jpg',
      'Hiking':
          'https://www.travelandleisure.com/thmb/OmGhzSe-6Q6aC3aeCoZfdoBAs08=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/19-mount-rainier-national-park-washington-BESTHIKE0407-1b2ae69a788f49a996e64ff38f05275a.jpg',
      'Nature':
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80',
      'Adventure':
          'https://images.unsplash.com/photo-1533130061792-64b345e4a833?w=800&q=80',
      'Historical':
          'https://lh7-us.googleusercontent.com/0ok5LCBmiioUwTpavyKDguR4QoTnyVLOFmoXAgfUjveBxNWgPXQ4aSMyLdzJsuRpryUakHdWOEOnzx3dH2cmapaXxOOWjbPAuh_dG4NBOtYcwinKhXQmThJfsoD5bwF3HxH5yekfXo9c-0jhpoCH1g',
      'Food':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    };
    return categoryImages[category] ??
        'https://industry.fersa.com/media/catalog/product/cache/44f599743c1dc4f12bba69d4eec200c5/n/k/nke_dummy_npa.png';
  }
}
