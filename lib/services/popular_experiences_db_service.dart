/*
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/popular_experiences.dart';

Future<List<PopularExperience>> fetchPopularExperiences() async {
  final snapshot =
  await FirebaseFirestore.instance.collection('popular_experiences').get();

  return snapshot.docs
      .map((doc) => PopularExperience.fromFirestore(doc.data() as Map<String, dynamic>))
      .toList();
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/popular_experiences.dart';

class PopularExperienceService {
  // Fetch Popular Experiences from Firestore as a stream (real-time updates)
  Stream<List<PopularExperience>> streamPopularExperiences() {
    return FirebaseFirestore.instance
        .collection('popular_experiences')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PopularExperience.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Store a new experience in Firestore
  Future<void> storePopularExperience(PopularExperience experience) async {
    try {
      // Use a unique document ID, such as the experience name or ID.
      String documentId = experience.name; // or another unique identifier from `experience`

      await FirebaseFirestore.instance
          .collection('popular_experiences')
          .doc(documentId)
          .set(
        experience.toFirestore(), // Convert the PopularExperience object to a map
      );
    } catch (e) {
      print("Error storing experience: $e");
    }
  }
}
