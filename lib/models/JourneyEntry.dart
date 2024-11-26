// // journey_entry.dart
// class JourneyEntry {
//   final String day;
//   final String email;
//   final String locationName;
//   final String placeId;
//   final String address;
//   final String googleMapsUri;
//   final double latitude;
//   final double longitude;
//   final List<String> photoUrls;
//   final int daycount;
//
//   JourneyEntry({
//     required this.day,
//     required this.email,
//     required this.locationName,
//     required this.placeId,
//     required this.address,
//     required this.googleMapsUri,
//     required this.latitude,
//     required this.longitude,
//     required this.photoUrls,
//     required this.daycount,
//   });
//
//   // Convert the object into a JSON map to store in the database.
//   Map<String, dynamic> toJson() {
//     return {
//       'day': day,
//       'email': email,
//       'locationName': locationName,
//       'placeId': placeId,
//       'address': address,
//       'googleMapsUri': googleMapsUri,
//       'latitude': latitude,
//       'longitude': longitude,
//       'photoUrls': photoUrls,
//       'daycount':daycount,
//     };
//   }
// }
class JourneyEntry {
  final String? day;            // Represents the day of the journey (optional)
  final String email;           // Email address associated with the entry
  final String locationName;    // Name of the location
  final String description;     // Description of the location or activity
  final String city;            // City where the location is situated
  final String openHours;       // Operating hours for the location
  final String priceRange;      // Price range for activities or entry fees
  final double userRating;      // User rating for the location/activity
  final double latitude;        // Latitude of the location
  final double longitude;       // Longitude of the location
  final List<String> photoUrls; // List of photo URLs for the location
  final int dayCount;           // Count of days for the journey

  JourneyEntry({
    this.day, // Made `day` optional
    required this.email,
    required this.locationName,
    required this.description,
    required this.city,
    required this.openHours,
    required this.priceRange,
    required this.userRating,
    required this.latitude,
    required this.longitude,
    required this.photoUrls,
    required this.dayCount,
  });

  // Example method for converting from a Firestore document
  factory JourneyEntry.fromFirestore(Map<String, dynamic> data) {
    return JourneyEntry(
      day: data['day'] as String?, // Handle `day` as nullable
      email: data['email'] as String,
      locationName: data['locationName'] as String,
      description: data['description'] as String,
      city: data['city'] as String,
      openHours: data['openHours'] as String,
      priceRange: data['price_range'] as String,
      userRating: data['user_rating'] as double,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      photoUrls: List<String>.from(data['photoUrls'] as List<dynamic>),
      dayCount: data['daycount'] as int,
    );
  }

  // Example method for converting to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'day': day, // Handle optional `day` field
      'email': email,
      'locationName': locationName,
      'description': description,
      'city': city,
      'openHours': openHours,
      'price_range': priceRange,
      'user_rating': userRating,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrls': photoUrls,
      'daycount': dayCount,
    };
  }
}

