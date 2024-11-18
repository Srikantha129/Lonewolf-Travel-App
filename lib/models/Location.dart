import 'Location.dart';

class Location {
  final String name;
  final String imageUrl;
  final List<String> hashtags;

  Location({
    required this.name,
    required this.imageUrl,
    required this.hashtags,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      hashtags: List<String>.from(json['hashtags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'hashtags': hashtags,
  };

}
