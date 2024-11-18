// personal_journey_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalJourneyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addJourney(String email, Map<String, dynamic> journey) async {
    try {
      await _firestore
          .collection('personaljourneys')
          .doc(email)
          .set({'entries': FieldValue.arrayUnion([journey])}, SetOptions(merge: true));
      print('Journey added successfully for $email');
    } catch (e) {
      print('Error adding journey: $e');
    }
  }
}




