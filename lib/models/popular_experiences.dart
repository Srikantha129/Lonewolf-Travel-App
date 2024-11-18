/*
class PopularExperience {
  final String name;
  final List<String> images; // List of image URLs
  final String type;
  final String price;
  final String rating;

  PopularExperience({
    required this.name,
    required this.images,
    required this.type,
    required this.price,
    required this.rating,
  });

  factory PopularExperience.fromFirestore(Map<String, dynamic> data) {
    return PopularExperience(
      name: data['name'] ?? '',
      images: List<String>.from(data['images'] ?? []), // Converting to List<String>
      type: data['type'] ?? '',
      price: data['price'] ?? '',
      rating: data['rating'] ?? '',
    );
  }
}

*/
class PopularExperience {
  final String name;
  final String description;
  final List<String> images; // List of image URLs (or Base64 strings if you're storing them that way)
  final String duration;
  final bool isEquipmentIncluded;
  final int maxPeople;
  final List<String> languages;
  final String hostId;
  final String hostName;
  final String type;
  final double price;
  //final double rating;

  PopularExperience({
    required this.name,
    required this.description,
    required this.images,
    required this.duration,
    required this.isEquipmentIncluded,
    required this.maxPeople,
    required this.languages,
    required this.hostId,
    required this.hostName,
    required this.type,
    required this.price,
    //required this.rating,
  });

  factory PopularExperience.fromFirestore(Map<String, dynamic> data) {
    return PopularExperience(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      duration: data['duration'] ?? '',
      isEquipmentIncluded: data['equipmentIncluded'] ?? false,
      maxPeople: data['maxPeople'] ?? 1,
      languages: List<String>.from(data['languages'] ?? []),
      hostId: data['hostId'] ?? '',
      hostName: data['hostName'] ?? '',
      type: data['type'] ?? '',
      price: (data['price'] is int ? (data['price'] as int).toDouble() : data['price']) ?? 0.0, // Ensure price is a double
      //rating: data['ratings'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'duration': duration,
      'equipmentIncluded': isEquipmentIncluded,
      'maxPeople': maxPeople,
      'languages': languages,
      'hostId': hostId,
      'hostName': hostName,
      'type': type,
      'price': price,
      //'rating': rating,
    };
  }
}
