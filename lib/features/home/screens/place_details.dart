import 'package:flutter/material.dart';
import 'package:ride_lanka/features/home/models/explore_place_model.dart';
import 'package:ride_lanka/features/home/models/nearby_place_model.dart';
import 'package:ride_lanka/features/home/models/popular_place_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ride_lanka/features/home/widgets/place_details_bottom_bar.dart';
import 'package:ride_lanka/features/home/widgets/place_details_info_card.dart';
import 'package:shimmer/shimmer.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  String? _mapUrl;
  bool _isLoadingMap = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final place = args?['place'];
      if (place != null) {
        _fetchMap(place);
      } else {
        setState(() {
          _isLoadingMap = false;
        });
      }
    }
  }

  Future<void> _fetchMap(dynamic place) async {
    final title = _getTitle(place);
    final location = _getLocation(place);
    final query = "$title, $location, Sri Lanka";

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final lat = locations.first.latitude;
        final lng = locations.first.longitude;

        setState(() {
          _mapUrl =
              'https://static-maps.yandex.ru/1.x/?ll=$lng,$lat&size=600,300&z=13&l=map&pt=$lng,$lat,pm2rdm';
          _isLoadingMap = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Geocoding error for map: $e');
    }

    setState(() {
      _mapUrl =
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80';
      _isLoadingMap = false;
    });
  }

  String _getId(dynamic place) {
    if (place is NearbyPlaceModel) return place.id;
    if (place is PopularPlaceModel) return place.id;
    if (place is ExplorePlaceModel) return place.id;
    return '';
  }

  String _getTitle(dynamic place) {
    if (place is NearbyPlaceModel) return place.title;
    if (place is PopularPlaceModel) return place.title;
    if (place is ExplorePlaceModel) return place.title;
    return 'Sri Dalada Maligawa';
  }

  String _getCategory(dynamic place) {
    if (place is NearbyPlaceModel) return place.category;
    if (place is PopularPlaceModel) return place.category;
    return 'Culture';
  }

  String _getLocation(dynamic place) {
    if (place is PopularPlaceModel) return place.location;
    return 'Kandy';
  }

  String _getDistance(dynamic place) {
    if (place is NearbyPlaceModel) return place.distance;
    if (place is PopularPlaceModel) return place.distance;
    return '12.2km';
  }

  String _getImageUrl(dynamic place) {
    if (place is NearbyPlaceModel) return place.imageUrl;
    if (place is PopularPlaceModel) return place.imageUrl;
    if (place is ExplorePlaceModel) return place.imageUrl;
    return 'https://images.unsplash.com/photo-1588096344390-8b0101b44917?w=800&q=80';
  }

  double _getRating(dynamic place) {
    if (place is NearbyPlaceModel) return place.rating;
    if (place is PopularPlaceModel) return place.rating;
    return 4.7;
  }

  int _getReviewsCount(dynamic place) {
    if (place is NearbyPlaceModel) return place.reviewsCount;
    if (place is PopularPlaceModel) return place.reviews;
    return 355;
  }

  String _getDescription(dynamic place) {
    if (place is ExplorePlaceModel) return place.snippet;
    return 'Large temple featuring rituals and services around the sacred Tooth Relic, the canine tooth of Buddha';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final place = args?['place'];

    final size = MediaQuery.of(context).size;
    final String id = _getId(place);
    final String title = _getTitle(place);
    final String category = _getCategory(place);
    final String location = _getLocation(place);
    final String distance = _getDistance(place);
    final double rating = _getRating(place);
    final int reviewsCount = _getReviewsCount(place);
    final String description = _getDescription(place);
    final String imageUrl = _getImageUrl(place);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      );
                    },
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/imgplaceholder.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: List.generate(
                            6,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == 1
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
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

          Positioned(
            top: size.height * 0.38,
            left: 0,
            right: 0,
            bottom: 90,
            child: PlaceDetailsInfoCard(
              id: id,
              category: category,
              title: title,
              location: location,
              distance: distance,
              rating: rating,
              reviewsCount: reviewsCount,
              description: description,
              isLoadingMap: _isLoadingMap,
              mapUrl: _mapUrl,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: PlaceDetailsBottomBar(
                title: title,
                location: location,
                rating: rating,
                reviewsCount: reviewsCount,
                distance: distance,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
