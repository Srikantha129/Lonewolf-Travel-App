import 'Location.dart';

class JourneyLocation {
  final String name;
  final String imageUrl;
  final List<String> hashtags;

  JourneyLocation({
    required this.name,
    required this.imageUrl,
    required this.hashtags,
  });

  factory JourneyLocation.fromJson(Map<String, dynamic> json) {
    return JourneyLocation(
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
