class Post {
  final String title;
  final String createdOn;
  final String fullDescription;
  final String shortDescription;
  // final Map<String, String> hashtags;
  final String hashtag1;
  final String hashtag2;
  final String hashtag3;
  final String photoUrl1;
  final String photoUrl2;
  final String photoUrl3;
  final String photoUrl4;
  final String mapUrl;
  // final List<String> photoUrls;

  Post({
    required this.title,
    required this.createdOn,
    required this.fullDescription,
    required this.shortDescription,
    required this.hashtag1,
    required this.hashtag2,
    required this.hashtag3,
    required this.photoUrl1,
    required this.photoUrl2,
    required this.photoUrl3,
    required this.photoUrl4,
    required this.mapUrl,
    // required this.hashtags,
    // required this.photoUrls,

  });

  Post.fromJson(Map<String, Object?> json) : this(
    title: json['title']! as String,
    createdOn: json['createdOn']! as String,
    fullDescription: json['fullDescription']! as String,
    shortDescription: json['shortDescription']! as String,
    hashtag1: json['hashtag1']! as String,
    hashtag2: json['hashtag2']! as String,
    hashtag3: json['hashtag3']! as String,
    photoUrl1: json['photoUrl1']! as String,
    photoUrl2: json['photoUrl2']! as String,
    photoUrl3: json['photoUrl3']! as String,
    photoUrl4: json['photoUrl4']! as String,
    mapUrl: json['mapUrl']! as String,
    // hashtags: (json['hashtags'] as List<dynamic>?)?.cast<String>() ?? [],
    // photoUrls: (json['photoUrls'] as List<dynamic>?)?.cast<String?>() ?? [], // Parse photo URLs (optional)
  );

  Map<String, Object?> toJson() => {
    'title': title,
    'createdOn': createdOn,
    'fullDescription': fullDescription,
    'shortDescription': shortDescription,
    'hashtag1': hashtag1,
    'hashtag2': hashtag2,
    'hashtag3': hashtag3,
    'photoUrl1': photoUrl1,
    'photoUrl2': photoUrl2,
    'photoUrl3': photoUrl3,
    'photoUrl4': photoUrl4,
    'mapUrl': mapUrl,
  };

}
