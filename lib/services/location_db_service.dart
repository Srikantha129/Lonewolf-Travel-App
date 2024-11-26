import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Journey.dart';
import '../models/Location.dart';

const String COLLECTION_REF = "locations";

class LocationDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _locationRef;

  LocationDbService() {
    _locationRef = _firestore.collection(COLLECTION_REF).withConverter<JourneyLocation>(
        fromFirestore: (snapshots, _) =>
            JourneyLocation.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (locations, _) => locations.toJson());
  }

  Future<List<JourneyLocation>> getLocations() async {
    final querySnapshot = await _locationRef.get();
    return querySnapshot.docs.map((doc) => doc.data() as JourneyLocation).toList();
  }

  void addLocation(JourneyLocation location) async {
    _locationRef.add(location);
  }

  void updateLocation(String locationId, JourneyLocation location) {
    _locationRef.doc(locationId).update(location.toJson());
  }

  void deleteLocation(String locationId) {
    _locationRef.doc(locationId).delete();
  }

  // Function to calculate match score
  int calculateMatchScore(List<String> journeyInterests, List<String> locationInterests) {
    int matchCount = 0;
    for (final interest in journeyInterests) {
      if (locationInterests.contains(interest)) {
        matchCount++;
      }
    }
    return matchCount;
  }

  Stream<QuerySnapshot> getLocationByName(String name) {
    return _locationRef.where('name', isEqualTo: name).snapshots();
  }

  // Future<List<Location>> getMatchingLocations(Journey journey) async {
  //   final locationsSnapshot = await FirebaseFirestore.instance.collection('locations').get();
  //   final locations = locationsSnapshot.docs.map((doc) => Location.fromJson(doc.data())).toList();
  //
  //   // Ensure matchScore is a comparable type (e.g., int)
  //   final sortedLocations = locations.map((location) {
  //     final matchScore = calculateMatchScore(journey.selectedInterests, location.hashtags);
  //     return {'location': location, 'matchScore': matchScore};
  //   }).toList();
  //
  //   // Sort based on matchScore (assuming it's an int)
  //   sortedLocations.sort((a, b) => b['matchScore']!.compareTo(a['matchScore']!));
  //
  //   return sortedLocations.map((item) => item['location'] as Location).toList();
  // }
}
