/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lonewolf/models/new_places.dart';

class AdventureService {
  /// Fetches all AdventureData from the 'cached_locations' collection.
  Future<List<AdventureData>> getAllAdventureData() async {
    try {
      // Get all documents from 'cached_locations' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cached_locations')
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint("No documents found in 'cached_locations'.");
        return [];
      }

      // Map documents to AdventureData list
      return snapshot.docs.map((doc) {
        return AdventureData.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching adventure data: $e");
      return [];
    }
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/new_places.dart';

const String COLLECTION_REF = "cached_locations";

class CachedLocationDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<CachedLocation> _cachedLocationRef;

  CachedLocationDbService() {
    _cachedLocationRef = _firestore.collection(COLLECTION_REF).withConverter<CachedLocation>(
      fromFirestore: (snapshot, _) => CachedLocation.fromJson(snapshot.data()!),
      toFirestore: (cachedLocation, _) => cachedLocation.toJson(),
    );
  }

  Future<List<CachedLocation>> getCachedLocations() async {
    final querySnapshot = await _cachedLocationRef.get();
    return querySnapshot.docs.map((doc) => doc.data() as CachedLocation).toList();
  }

  Future<void> addCachedLocation(CachedLocation cachedLocation) async {
    await _cachedLocationRef.add(cachedLocation);
  }

  Future<void> updateCachedLocation(String locationId, CachedLocation cachedLocation) async {
    await _cachedLocationRef.doc(locationId).update(cachedLocation.toJson());
  }

  Future<void> deleteCachedLocation(String locationId) async {
    await _cachedLocationRef.doc(locationId).delete();
  }
}
