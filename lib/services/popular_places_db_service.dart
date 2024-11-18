import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lonewolf/models/popular_places.dart';

const String COLLECTION_REF = "popular_places"; // Change this to your actual collection name

class PopularPlaceDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _popularPlaceRef;

  PopularPlaceDbService() {
    _popularPlaceRef = _firestore.collection(COLLECTION_REF).withConverter<PopularPlace>(
      fromFirestore: (snapshots, _) => PopularPlace.fromJson(snapshots.data()!),
      toFirestore: (popularPlace, _) => popularPlace.toJson(),
    );
  }

  Future<List<PopularPlace>> getPopularPlaces() async {
    final querySnapshot = await _popularPlaceRef.get();
    return querySnapshot.docs.map((doc) => doc.data() as PopularPlace).toList();
  }

  void addPopularPlace(PopularPlace popularPlace) async {
    _popularPlaceRef.add(popularPlace);
  }

  void updatePopularPlace(String placeId, PopularPlace popularPlace) {
    _popularPlaceRef.doc(placeId).update(popularPlace.toJson());
  }

  void deletePopularPlace(String placeId) {
    _popularPlaceRef.doc(placeId).delete();
  }
}
