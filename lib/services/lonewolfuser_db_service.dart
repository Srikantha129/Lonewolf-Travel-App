import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/LoneWolfUser.dart';

const String USER_COLLECTION_REF = "users";

class LonewolfuserDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  LonewolfuserDbService() {
    _usersRef =
        _firestore.collection(USER_COLLECTION_REF).withConverter<LoneWolfUser>(
            fromFirestore: (snapshots, _) => LoneWolfUser.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (users, _) => users.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  void addUsers(LoneWolfUser user) async {
    _usersRef.add(user);
  }

  void updateUser(String userId, LoneWolfUser user) {
    _usersRef.doc(userId).update(user.toJson());
  }

  void deleteUser(String userId) {
    _usersRef.doc(userId).delete();
  }

  Future<bool> findUserExists(String? email) async {
    final querySnapshot =
        await _usersRef.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Future<QuerySnapshot<Object?>> getUserById(String email) async {
  //   return await _usersRef.where('email', isEqualTo: email).limit(1).get();
  // }
}
