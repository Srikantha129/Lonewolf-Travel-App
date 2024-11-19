import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hotels.dart';

class HotelService {
  final FirebaseFirestore _firestore;

  HotelService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Hotel>> getHotels() {
    return _firestore.collection('hotels').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Hotel.fromFirestore(data);
      }).toList();
    });
  }
}
