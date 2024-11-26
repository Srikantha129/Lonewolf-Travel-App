/*

class AdventureData {
  //String mainPreference;
  List<Place> places;
  //List<String> secondaryPreferences;
  //DateTime timestamp;

  AdventureData({
    //required this.mainPreference,
    required this.places,
    //required this.secondaryPreferences,
    //required this.timestamp,
  });

  factory AdventureData.fromJson(Map<String, dynamic> json) => AdventureData(
   // mainPreference: json["mainPreference"],
    places: List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
    //secondaryPreferences: List<String>.from(json["secondaryPreferences"].map((x) => x)),
   // timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    //"mainPreference": mainPreference,
    "places": List<dynamic>.from(places.map((x) => x.toJson())),
    //"secondaryPreferences": List<dynamic>.from(secondaryPreferences.map((x) => x)),
   // "timestamp": timestamp.toIso8601String(),
  };
}

class Place {
  //String googleMapsUri;
 // List<String>? photoUrls;
  //String formattedAddress;
  DisplayName displayName;
  //double rating;
  //int userRatingCount;
  //Location location;
  String id;
  //List<Photo>? photos;
  //RegularOpeningHours? regularOpeningHours;
  //String? websiteUri;
  //String? nationalPhoneNumber;

  Place({
    //required this.googleMapsUri,
    //this.photoUrls,
    //required this.formattedAddress,
    required this.displayName,
    //required this.rating,
    //required this.userRatingCount,
    //required this.location,
    required this.id,
    //this.photos,
    // this.regularOpeningHours,
    // this.websiteUri,
    // this.nationalPhoneNumber,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    //googleMapsUri: json["googleMapsUri"],
    //photoUrls: json["photoUrls"] == null ? [] : List<String>.from(json["photoUrls"]!.map((x) => x)),
    //formattedAddress: json["formattedAddress"],
    displayName: DisplayName.fromJson(json["displayName"]),
    //rating: json["rating"]?.toDouble(),
    //userRatingCount: json["userRatingCount"],
    // location: Location.fromJson(json["location"]),
    id: json["id"],
    //photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
    // regularOpeningHours: json["regularOpeningHours"] == null ? null : RegularOpeningHours.fromJson(json["regularOpeningHours"]),
    // websiteUri: json["websiteUri"],
    // nationalPhoneNumber: json["nationalPhoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    //"googleMapsUri": googleMapsUri,
    //"photoUrls": photoUrls == null ? [] : List<dynamic>.from(photoUrls!.map((x) => x)),
    //"formattedAddress": formattedAddress,
    "displayName": displayName.toJson(),
    //"rating": rating,
    //"userRatingCount": userRatingCount,
    // "location": location.toJson(),
    "id": id,
    //"photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    // "regularOpeningHours": regularOpeningHours?.toJson(),
    // "websiteUri": websiteUri,
    // "nationalPhoneNumber": nationalPhoneNumber,
  };
}

class DisplayName {
  String text;
  LanguageCode languageCode;

  DisplayName({
    required this.text,
    required this.languageCode,
  });

  factory DisplayName.fromJson(Map<String, dynamic> json) => DisplayName(
    text: json["text"],
    languageCode: languageCodeValues.map[json["languageCode"]]!,
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "languageCode": languageCodeValues.reverse[languageCode],
  };
}

enum LanguageCode {
  EN
}

final languageCodeValues = EnumValues({
  "en": LanguageCode.EN
});

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Photo {
  String flagContentUri;
  List<AuthorAttribution> authorAttributions;
  String googleMapsUri;
  int widthPx;
  int heightPx;
  String name;

  Photo({
    required this.flagContentUri,
    required this.authorAttributions,
    required this.googleMapsUri,
    required this.widthPx,
    required this.heightPx,
    required this.name,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    flagContentUri: json["flagContentUri"],
    authorAttributions: List<AuthorAttribution>.from(json["authorAttributions"].map((x) => AuthorAttribution.fromJson(x))),
    googleMapsUri: json["googleMapsUri"],
    widthPx: json["widthPx"],
    heightPx: json["heightPx"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "flagContentUri": flagContentUri,
    "authorAttributions": List<dynamic>.from(authorAttributions.map((x) => x.toJson())),
    "googleMapsUri": googleMapsUri,
    "widthPx": widthPx,
    "heightPx": heightPx,
    "name": name,
  };
}

class AuthorAttribution {
  String photoUri;
  String displayName;
  String uri;

  AuthorAttribution({
    required this.photoUri,
    required this.displayName,
    required this.uri,
  });

  factory AuthorAttribution.fromJson(Map<String, dynamic> json) => AuthorAttribution(
    photoUri: json["photoUri"],
    displayName: json["displayName"],
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "photoUri": photoUri,
    "displayName": displayName,
    "uri": uri,
  };
}

class RegularOpeningHours {
  bool openNow;
  List<Period> periods;
  DateTime? nextCloseTime;
  List<String> weekdayDescriptions;
  DateTime? nextOpenTime;

  RegularOpeningHours({
    required this.openNow,
    required this.periods,
    this.nextCloseTime,
    required this.weekdayDescriptions,
    this.nextOpenTime,
  });

  factory RegularOpeningHours.fromJson(Map<String, dynamic> json) => RegularOpeningHours(
    openNow: json["openNow"],
    periods: List<Period>.from(json["periods"].map((x) => Period.fromJson(x))),
    nextCloseTime: json["nextCloseTime"] == null ? null : DateTime.parse(json["nextCloseTime"]),
    weekdayDescriptions: List<String>.from(json["weekdayDescriptions"].map((x) => x)),
    nextOpenTime: json["nextOpenTime"] == null ? null : DateTime.parse(json["nextOpenTime"]),
  );

  Map<String, dynamic> toJson() => {
    "openNow": openNow,
    "periods": List<dynamic>.from(periods.map((x) => x.toJson())),
    "nextCloseTime": nextCloseTime?.toIso8601String(),
    "weekdayDescriptions": List<dynamic>.from(weekdayDescriptions.map((x) => x)),
    "nextOpenTime": nextOpenTime?.toIso8601String(),
  };
}

class Period {
  Open? close;
  Open open;

  Period({
    this.close,
    required this.open,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    close: json["close"] == null ? null : Open.fromJson(json["close"]),
    open: Open.fromJson(json["open"]),
  );

  Map<String, dynamic> toJson() => {
    "close": close?.toJson(),
    "open": open.toJson(),
  };
}

class Open {
  int hour;
  int day;
  int minute;

  Open({
    required this.hour,
    required this.day,
    required this.minute,
  });

  factory Open.fromJson(Map<String, dynamic> json) => Open(
    hour: json["hour"],
    day: json["day"],
    minute: json["minute"],
  );

  Map<String, dynamic> toJson() => {
    "hour": hour,
    "day": day,
    "minute": minute,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
*/

/*class CachedLocation {
  final String? mainPreference;
  final List<Place>? places;
  final List<String>? secondaryPreferences; // Added nullable list

  CachedLocation({
    this.mainPreference,
    this.places,
    this.secondaryPreferences, // Include it in the constructor
  });

  factory CachedLocation.fromJson(Map<String, dynamic> json) {
    return CachedLocation(
      mainPreference: json['mainPreference'],
      places: (json['places'] as List?)?.map((place) => Place.fromJson(place)).toList(),
      secondaryPreferences: (json['secondaryPreferences'] as List?)?.cast<String>(), // Handle nullable list
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainPreference': mainPreference,
      'places': places?.map((place) => place.toJson()).toList(),
      'secondaryPreferences': secondaryPreferences, // Serialize nullable list
    };
  }
}


class Place {
  final String? googleMapsUri;
  final List<String>? photoUrls;
  final String? formattedAddress;
  final DisplayName? displayName;
  //final double? rating;
  final int? userRatingCount;
  final Location? location;
  final String? id;

  Place({
    this.googleMapsUri,
    this.photoUrls,
    this.formattedAddress,
    this.displayName,
    //this.rating,
    this.userRatingCount,
    this.location,
    this.id,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      googleMapsUri: json['googleMapsUri'],
      photoUrls: json['photoUrls']?.cast<String>(),
      formattedAddress: json['formattedAddress'],
      displayName: json['displayName'] != null ? DisplayName.fromJson(json['displayName']) : null,
      //rating: json['rating'] != null ? json['rating'].toDouble() : null,
      userRatingCount: json['userRatingCount'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleMapsUri': googleMapsUri,
      'photoUrls': photoUrls,
      'formattedAddress': formattedAddress,
      'displayName': displayName?.toJson(),
      //'rating': rating,
      'userRatingCount': userRatingCount,
      'location': location?.toJson(),
      'id': id,
    };
  }
}

class DisplayName {
  final String? text;
  final String? languageCode;

  DisplayName({
    this.text,
    this.languageCode,
  });

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'],
      languageCode: json['languageCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'languageCode': languageCode,
    };
  }
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}*/

class CachedLocation {
  final String? mainPreference;
  final List<String>? secondaryPreferences; // Added nullable secondaryPreferences
  final List<Place>? places;

  CachedLocation({
    this.mainPreference,
    this.secondaryPreferences,
    this.places,
  });

  factory CachedLocation.fromJson(Map<String, dynamic> json) {
    return CachedLocation(
      mainPreference: json['mainPreference'],
      secondaryPreferences: json['secondaryPreferences'] != null
          ? List<String>.from(json['secondaryPreferences'])
          : null, // Handling nullable secondaryPreferences
      places: json['places'] != null
          ? (json['places'] as List).map((place) => Place.fromJson(place)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainPreference': mainPreference,
      'secondaryPreferences': secondaryPreferences,
      'places': places?.map((place) => place.toJson()).toList(),
    };
  }
}


class Place {
  final String? googleMapsUri;
  final List<String>? photoUrls;
  final String? formattedAddress;
  final DisplayName? displayName;
  final double? rating;
  final int? userRatingCount;
  final Location location;  // This is non-nullable
  final String? id;
  final OpeningHours? regularOpeningHours;

  Place({
    this.googleMapsUri,
    this.photoUrls,
    this.formattedAddress,
    this.displayName,
    this.rating,
    this.userRatingCount,
    required this.location,
    this.id,
    this.regularOpeningHours,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      googleMapsUri: json['googleMapsUri'],
      photoUrls: json['photoUrls']?.cast<String>(),
      formattedAddress: json['formattedAddress'],
      displayName: json['displayName'] != null ? DisplayName.fromJson(json['displayName']) : null,
      rating: json['rating']?.toDouble(),
      userRatingCount: json['userRatingCount'],
      location: Location.fromJson(json['location']),
      id: json['id'],
      regularOpeningHours: json['regularOpeningHours'] != null
          ? OpeningHours.fromJson(json['regularOpeningHours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleMapsUri': googleMapsUri,
      'photoUrls': photoUrls,
      'formattedAddress': formattedAddress,
      'displayName': displayName?.toJson(),
      'rating': rating,
      'userRatingCount': userRatingCount,
      'location': location.toJson(),
      'id': id,
      'regularOpeningHours': regularOpeningHours?.toJson(),
    };
  }
}

class DisplayName {
  final String? text;
  final String? languageCode;

  DisplayName({
    this.text,
    this.languageCode,
  });

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'],
      languageCode: json['languageCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'languageCode': languageCode,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class OpeningHours {
  final bool? openNow;
  final List<OpeningPeriod>? periods;
  final List<String>? weekdayDescriptions;
  final String? nextCloseTime;
  final String? nextOpenTime;

  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayDescriptions,
    this.nextCloseTime,
    this.nextOpenTime,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json['openNow'],
      periods: json['periods'] != null
          ? (json['periods'] as List).map((period) => OpeningPeriod.fromJson(period)).toList()
          : null,
      weekdayDescriptions: json['weekdayDescriptions'] != null
          ? List<String>.from(json['weekdayDescriptions'])
          : null,
      nextCloseTime: json['nextCloseTime'],
      nextOpenTime: json['nextOpenTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openNow': openNow,
      'periods': periods?.map((period) => period.toJson()).toList(),
      'weekdayDescriptions': weekdayDescriptions,
      'nextCloseTime': nextCloseTime,
      'nextOpenTime': nextOpenTime,
    };
  }
}

class OpeningPeriod {
  final Time? open;
  final Time? close;

  OpeningPeriod({
    this.open,
    this.close,
  });

  factory OpeningPeriod.fromJson(Map<String, dynamic> json) {
    return OpeningPeriod(
      open: json['open'] != null ? Time.fromJson(json['open']) : null,
      close: json['close'] != null ? Time.fromJson(json['close']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open?.toJson(),
      'close': close?.toJson(),
    };
  }
}

class Time {
  final int? hour;
  final int? day;
  final int? minute;

  Time({
    this.hour,
    this.day,
    this.minute,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      hour: json['hour'],
      day: json['day'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'day': day,
      'minute': minute,
    };
  }
}
