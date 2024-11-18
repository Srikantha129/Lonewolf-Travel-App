class Place {

  final String id;
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String googleMapsUri;
  final String displayNameText;
  final String displayNameLanguageCode;
  final List<String>? photos;


  Place({
    required this.id,

    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUri,
    required this.displayNameText,
    required this.displayNameLanguageCode,
    this.photos,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(

      id: json['id'],
      formattedAddress: json['formattedAddress'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      googleMapsUri: json['googleMapsUri'],
      displayNameText: json['displayName']['text'],
      displayNameLanguageCode: json['displayName']['languageCode'],
      photos: json['photos'] != null
          ? List<String>.from(json['photos'].map((photo) => photo['name']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'id': id,
      'formattedAddress': formattedAddress,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'googleMapsUri': googleMapsUri,
      'displayName': {
        'text': displayNameText,
        'languageCode': displayNameLanguageCode,
      },
      'photos': photos,
    };
  }

  @override
  String toString() {
    return 'Place{id: $id, formattedAddress: $formattedAddress, latitude: $latitude, longitude: $longitude, '
        'googleMapsUri: $googleMapsUri, displayNameText: $displayNameText, '
        'displayNameLanguageCode: $displayNameLanguageCode, photos: ${photos?.join(", ")}}';
  }
}


class PlacePhotos {
  final String placeId;
  final List<String> photoUrls;

  PlacePhotos({required this.placeId, required this.photoUrls});
  @override
  String toString() {
    return 'PlacePhotos(placeId: $placeId, photoUrls: $photoUrls)';
  }
}


