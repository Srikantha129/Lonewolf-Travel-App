// journey_entry.dart
class JourneyEntry {
  final String day;
  final String email;
  final String locationName;
  final String placeId;
  final String address;
  final String googleMapsUri;
  final double latitude;
  final double longitude;
  final List<String> photoUrls;
  final int daycount;

  JourneyEntry({
    required this.day,
    required this.email,
    required this.locationName,
    required this.placeId,
    required this.address,
    required this.googleMapsUri,
    required this.latitude,
    required this.longitude,
    required this.photoUrls,
    required this.daycount,
  });

  // Convert the object into a JSON map to store in the database.
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'email': email,
      'locationName': locationName,
      'placeId': placeId,
      'address': address,
      'googleMapsUri': googleMapsUri,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrls': photoUrls,
      'daycount':daycount,
    };
  }
}
