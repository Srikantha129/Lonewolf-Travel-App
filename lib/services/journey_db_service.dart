import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Journey.dart';

const String COLLECTION_REF = "journeys";

class JourneyDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _journeyRef;

  JourneyDbService() {
    _journeyRef = _firestore.collection(COLLECTION_REF).withConverter<Journey>(
        fromFirestore: (snapshots, _) =>
            Journey.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (journeys, _) => journeys.toJson());
  }

  Stream<QuerySnapshot> getJourneys() {
    return _journeyRef.snapshots();
  }

  void addJourney(Journey journey) async {
    _journeyRef.add(journey);
  }

  void updateJourney(String journeyId, Journey journey) {
    _journeyRef.doc(journeyId).update(journey.toJson());
  }

  Future<void> deleteJourneyByEmail(String email) async {
    final snapshot = await _journeyRef.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Journeys deleted for email: $email');
    } else {
      print('No journeys found for email: $email');
    }
  }

  Stream<QuerySnapshot> getJourneysByEmail(String email) {
    return _journeyRef.where('email', isEqualTo: email).snapshots();
  }

  Future<bool> isExistsByEmail(String email) async {
    final snapshot = await _journeyRef.where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addJourneyIfNotExist(Journey journey) async {
    final exists = await isExistsByEmail(journey.email);
    if (!exists) {
      await _journeyRef.add(journey);
    }
  }

  Future<void> addJourneysByEmail(String email, Map<String, String> newJourneys) async {
    final snapshot = await _journeyRef.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      final journeyDoc = snapshot.docs.first;
      final journeyData = journeyDoc.data() as Journey;
      final existingJourneys = Map<String, String>.from(journeyData.journeys);
      existingJourneys.addAll(newJourneys);
      await journeyDoc.reference.update({'journeys': existingJourneys});
      print('Journeys added for email: $email');
    } else {
      print('No journey found for email: $email');
    }
  }

}
