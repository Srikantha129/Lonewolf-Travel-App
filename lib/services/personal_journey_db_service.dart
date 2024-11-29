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

  // Delete the entire document for the user's email
  Future<void> deleteUserJourneyDocument(String email) async {
    try {
      await _firestore
          .collection('personaljourneys')
          .doc(email)
          .delete();
      print('Document deleted successfully for $email');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<bool> isExistsByEmail(String email) async {
    try {
      final docSnapshot = await _firestore
          .collection('personaljourneys')
          .doc(email)
          .get();

      return docSnapshot.exists; // Returns true if the document exists
    } catch (e) {
      print('Error checking document existence: $e');
      return false; // In case of error, return false
    }
  }
}





