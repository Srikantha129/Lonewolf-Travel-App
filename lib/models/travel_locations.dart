class TravelLocation {
  final String displayName;
  final String city;
  final double longitude;
  final double latitude;
  final double userRating;
  final String description;
  final String priceRange;
  final List<String> photoUrls;
  final String openHours;

  TravelLocation({
    required this.displayName,
    required this.city,
    required this.longitude,
    required this.latitude,
    required this.userRating,
    required this.description,
    required this.priceRange,
    required this.photoUrls,
    required this.openHours,
  });

  // Factory constructor to create an instance from Firestore data
  factory TravelLocation.fromFirestore(Map<String, dynamic> data) {
    return TravelLocation(
      displayName: data['display_name'] ?? '',
      city: data['city'] ?? '',
      longitude: (data['longitude'] ?? 0).toDouble(),
      latitude: (data['latitude'] ?? 0).toDouble(),
      userRating: (data['user_rating'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      priceRange: data['price_range'] ?? '',
      photoUrls: List<String>.from(data['photo_urls'] ?? []),
      openHours: data['open_hours'] ?? '',
    );
  }

  // Method to convert the instance to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'display_name': displayName,
      'city': city,
      'longitude': longitude,
      'latitude': latitude,
      'user_rating': userRating,
      'description': description,
      'price_range': priceRange,
      'photo_urls': photoUrls,
      'open_hours': openHours,
    };
  }
}

class ActivityType {
  final String name;
  final List<TravelLocation> locations;

  ActivityType({
    required this.name,
    required this.locations,
  });

  // Factory constructor to create an instance from Firestore data
  factory ActivityType.fromFirestore(String name, Map<String, dynamic> data) {
    return ActivityType(
      name: name,
      locations: (data['locations'] as List<dynamic>)
          .map((location) => TravelLocation.fromFirestore(location))
          .toList(),
    );
  }

  // Method to convert the instance to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'locations': locations.map((location) => location.toFirestore()).toList(),
    };
  }
}
