class StopModel {
  final int stopOrder;
  final String name;
  final String description;
  final String? stopNote;
  final String? photoUrl;
  final String? userMemory;
  final String? userMemoryImg;
  final String? category;
  final double? lat;
  final double? lng;

  StopModel({
    required this.stopOrder,
    required this.name,
    required this.description,
    this.stopNote,
    this.photoUrl,
    this.userMemory,
    this.userMemoryImg,
    this.category,
    this.lat,
    this.lng,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      stopOrder: json['stop_order'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      stopNote: json['stop_note'],
      photoUrl: json['photo_url'],
      userMemory: json['user_memory'],
      userMemoryImg: json['user_memory_img'],
      category: json['category'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stop_order': stopOrder,
      'name': name,
      'description': description,
      if (stopNote != null) 'stop_note': stopNote,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (userMemory != null) 'user_memory': userMemory,
      if (userMemoryImg != null) 'user_memory_img': userMemoryImg,
      if (category != null) 'category': category,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}

class TripModel {
  final String? id;
  final String tripName;
  final String tripDate;
  final int stopCount;
  final String status;
  final List<String> favorites;
  final List<StopModel> stops;

  TripModel({
    this.id,
    required this.tripName,
    required this.tripDate,
    required this.stopCount,
    required this.status,
    required this.favorites,
    required this.stops,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    var rawStops = json['stops'] as List? ?? [];
    return TripModel(
      id: json['id']?.toString(),
      tripName: json['trip_name'] ?? '',
      tripDate: json['trip_date'] ?? '',
      stopCount: json['stop_count'] ?? 0,
      status: json['status'] ?? 'Upcoming',
      favorites: List<String>.from(json['favorites'] ?? []),
      stops: rawStops.map((e) => StopModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'trip_name': tripName,
      'trip_date': tripDate,
      'stop_count': stopCount,
      'status': status,
      'favorites': favorites,
      'stops': stops.map((e) => e.toJson()).toList(),
    };
  }
}
