import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/LoneWolfUser.dart';
import '../models/Post.dart';

const String COLLECTION_REF = "posts";

class PostDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsRef;

  PostDbService() {
    _postsRef = _firestore.collection(COLLECTION_REF).withConverter<Post>(
        fromFirestore: (snapshots, _) =>
            Post.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (posts, _) => posts.toJson());
  }

  Stream<QuerySnapshot> getPosts() {
    return _postsRef.snapshots();
  }

  void addPosts(Post post) async {
    _postsRef.add(post);
  }

  void updatePost(String postId, Post post) {
    _postsRef.doc(postId).update(post.toJson());
  }

  void deleteUser(String postId) {
    _postsRef.doc(postId).delete();
  }

}
