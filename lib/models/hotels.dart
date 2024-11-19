class Hotel {
  final String name;
  final int hotelId;
  final String country;
  final int districtId;
  final int cityId;
  final String url;
  final String zip;
  final int hotelClass;
  final String city;
  final String address;
  final String currency;
  final String defaultLanguage;
  final double exactClass;
  final int ranking;
  final int hotelTypeId;
  final int numberOfRooms;
  final String? licenseNumber;
  final bool bookDomesticWithoutCcDetails;
  final bool isWorkFriendly;
  final bool classIsEstimated;
  final bool? maxPersonsInReservation;
  final bool creditcardRequired;
  final bool preferred;
  final bool isClosed;
  final String hotelDescription;
  final String spokenLanguages;
  final double latitude;
  final double longitude;
  final Map<String, String>? checkinCheckoutTimes;
  final Map<String, dynamic>? additionalPolicies;
  final List<String>? photoUrls; // New field
  final List<Map<String, dynamic>>? avDates; // New field

  Hotel({
    required this.name,
    required this.hotelId,
    required this.country,
    required this.districtId,
    required this.cityId,
    required this.url,
    required this.zip,
    required this.hotelClass,
    required this.city,
    required this.address,
    required this.currency,
    required this.defaultLanguage,
    required this.exactClass,
    required this.ranking,
    required this.hotelTypeId,
    required this.numberOfRooms,
    this.licenseNumber,
    required this.bookDomesticWithoutCcDetails,
    required this.isWorkFriendly,
    required this.classIsEstimated,
    this.maxPersonsInReservation,
    required this.creditcardRequired,
    required this.preferred,
    required this.isClosed,
    required this.hotelDescription,
    required this.spokenLanguages,
    required this.latitude,
    required this.longitude,
    this.checkinCheckoutTimes,
    this.additionalPolicies,
    this.photoUrls, // Initialize new field
    this.avDates, // Initialize new field
  });

  // Factory constructor for creating a Hotel from Firestore
  /*factory Hotel.fromFirestore(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] as String,
      hotelId: json['hotel_id'] as int,
      country: json['country'] as String,
      districtId: json['district_id'] as int,
      cityId: json['city_id'] as int,
      url: json['url'] as String,
      zip: json['zip'] as String,
      hotelClass: json['hotel_class'] as int,
      city: json['city'] as String,
      address: json['address'] as String,
      currency: json['currency'] as String,
      defaultLanguage: json['default_language'] as String,
      exactClass: (json['exact_class'] as num).toDouble(),
      ranking: json['ranking'] as int,
      hotelTypeId: json['hotel_type_id'] as int,
      numberOfRooms: json['number_of_rooms'] as int,
      licenseNumber: json['license_number'] as String?,
      bookDomesticWithoutCcDetails:
      json['book_domestic_without_cc_details'] as bool,
      isWorkFriendly: json['is_work_friendly'] as bool,
      classIsEstimated: json['class_is_estimated'] as bool,
      maxPersonsInReservation: json['max_persons_in_reservation'] as bool?,
      creditcardRequired: json['creditcard_required'] as bool,
      preferred: json['preferred'] as bool,
      isClosed: json['is_closed'] as bool,
      hotelDescription: json['hotel_description'] as String,
      spokenLanguages: json['spoken_languages'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      checkinCheckoutTimes: json['checkin_checkout_times'] != null
          ? Map<String, String>.from(
          json['checkin_checkout_times'] as Map<String, dynamic>)
          : null,
      additionalPolicies: json['additional_policies'] as Map<String, dynamic>?,
      photoUrls: json['photo_urls'] != null
          ? List<String>.from(json['photo_urls'] as List)
          : null,
      avDates: json['av_dates'] != null
          ? List<String>.from(json['av_dates'] as List)
          : null,
    );
  }*/

  factory Hotel.fromFirestore(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] as String? ?? '',
      hotelId: json['hotel_id'] as int? ?? 0,
      country: json['country'] as String? ?? '',
      districtId: json['district_id'] as int? ?? 0,
      cityId: json['city_id'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      zip: json['zip'] as String? ?? '',
      hotelClass: json['hotel_class'] as int? ?? 0,
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      defaultLanguage: json['default_language'] as String? ?? '',
      exactClass: (json['exact_class'] as num?)?.toDouble() ?? 0.0,
      ranking: json['ranking'] as int? ?? 0,
      hotelTypeId: json['hotel_type_id'] as int? ?? 0,
      numberOfRooms: json['number_of_rooms'] as int? ?? 0,
      licenseNumber: json['license_number'] as String?,
      bookDomesticWithoutCcDetails:
      json['book_domestic_without_cc_details'] as bool? ?? false,
      isWorkFriendly: json['is_work_friendly'] as bool? ?? false,
      classIsEstimated: json['class_is_estimated'] as bool? ?? false,
      maxPersonsInReservation: json['max_persons_in_reservation'] as bool?,
      creditcardRequired: json['creditcard_required'] as bool? ?? false,
      preferred: json['preferred'] as bool? ?? false,
      isClosed: json['is_closed'] as bool? ?? false,
      hotelDescription: json['hotel_description'] as String? ?? '',
      spokenLanguages: json['spoken_languages'] as String? ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
      checkinCheckoutTimes: json['checkin_checkout_times'] != null
          ? Map<String, String>.from(
          json['checkin_checkout_times'] as Map<String, dynamic>)
          : null,
      additionalPolicies: json['additional_policies'] as Map<String, dynamic>?,
      avDates: json['avDates'] != null
          ? List<Map<String, dynamic>>.from(json['avDates'] as List)
          : null,
      photoUrls: json['photoUrls'] != null
          ? List<String>.from(json['photoUrls'] as List)
          : null,
    );
  }
  @override
  String toString() {
    return 'Hotel{name: $name, hotelId: $hotelId, country: $country, city: $city, address: $address, hotelClass: $hotelClass, exactClass: $exactClass, ranking: $ranking, latitude: $latitude, longitude: $longitude, photoUrls: $photoUrls, avDates: $avDates}';
  }

}
