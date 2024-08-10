import 'package:cloud_firestore/cloud_firestore.dart';

class Province {
  final String name;
  final String description;
  final String imageUrl;

  Province({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Province.fromDocument(DocumentSnapshot doc) {
    return Province(
      name: doc['provinceName'],
      description: doc['provinceDescriptions'],
      imageUrl: doc['imageUrl'],
    );
  }
}
