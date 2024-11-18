import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/LoneWolfUser.dart';

class BlogPage extends StatefulWidget {
  final String blogId;
  final User loggedUser;
  const BlogPage({required this.blogId, required this.loggedUser, super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();
  LoneWolfUser? user;
  bool isFavourited = false;
  double _averageRating = 0.0;
  double _userRating = 0.0;
  final List<int> _ratingsDistribution = List.filled(5, 0);

  @override
  void initState() {
    super.initState();
    _fetchUser(widget.loggedUser.email!);
    _fetchAverageRating();
  }

  Future<void> _fetchAverageRating() async {
    final ratingsSnapshot = await _firestore
        .collection('post')
        .doc(widget.blogId)
        .collection('ratings')
        .get();

    if (ratingsSnapshot.docs.isNotEmpty) {
      final ratings = ratingsSnapshot.docs.map((doc) => doc['rating'] as double).toList();
      setState(() {
        _averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
        _ratingsDistribution.fillRange(0, 5, 0); // Reset distribution

        for (var rating in ratings) {
          _ratingsDistribution[5 - rating.toInt()] += 1;
        }
      });
    }
  }

  Future<void> _submitRating(double rating) async {
    try {
      await _firestore
          .collection('post')
          .doc(widget.blogId)
          .collection('ratings')
          .doc(widget.loggedUser.uid)
          .set({'userId': widget.loggedUser.uid, 'rating': rating});

      _fetchAverageRating();
    } catch (e) {
      print('Error submitting rating: $e');
    }
  }

  Future<void> _fetchUser(String email) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (docSnapshot.size > 0) {
        final userData = docSnapshot.docs.first.data();
        setState(() {
          user = LoneWolfUser.fromJson(userData);
          if (user != null) {
            isFavourited = user!.favouritedPosts.contains(widget.blogId);
          }
        });

        final ratingSnapshot = await _firestore
            .collection('post')
            .doc(widget.blogId)
            .collection('ratings')
            .doc(widget.loggedUser.uid)
            .get();

        if (ratingSnapshot.exists) {
          setState(() {
            _userRating = ratingSnapshot['rating'].toDouble();
          });
        }
      } else {
        print('User not found in Firestore');
      }
    } on FirebaseException catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _addComment(String commentText) async {
    if (commentText.isEmpty) return;
    await _firestore.collection('post').doc(widget.blogId).collection('comments').add({
      'userId': widget.loggedUser.uid,
      'userEmail': widget.loggedUser.email,
      'userImage': widget.loggedUser.photoURL,
      'comment': commentText,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final blogNo = widget.blogId;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/images/Logo1.png',
          height: 30.0,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavourited = !isFavourited;
              });
            },
            icon: Icon(
              isFavourited ? Icons.favorite : Icons.favorite_border_outlined,
              color: isFavourited ? Colors.red : Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _auth.signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('post').doc(blogNo).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final Map<String, dynamic> blogData = snapshot.data!.data() as Map<String, dynamic>;
              final title = blogData['title'] as String;
              final createdOn = blogData['createdOn'] as String;
              final fullDescription = blogData['fullDescription'] as String;
              final shortDescription = blogData['shortDescription'] as String;
              final hashtag1 = blogData['hashtag1'] as String;
              final hashtag2 = blogData['hashtag2'] as String;
              final hashtag3 = blogData['hashtag3'] as String;
              final List<String> imagePaths = [
                blogData['photoUrl1'] as String,
                blogData['photoUrl2'] as String,
                blogData['photoUrl3'] as String,
                blogData['photoUrl4'] as String,
              ];
              final mapUrl = blogData['mapUrl'] as String;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(createdOn, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16.0),
                  CarouselSlider(
                    options: CarouselOptions(height: 300, autoPlay: true, enlargeCenterPage: true),
                    items: imagePaths.map((imagePath) => ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(imagePath, fit: BoxFit.cover))).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(shortDescription, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 10),
                  Text(fullDescription, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 20),
                  Wrap(spacing: 8.0, runSpacing: 4.0, children: [hashtag1, hashtag2, hashtag3].map((hashtag) => Chip(label: Text(hashtag, style: const TextStyle(color: Colors.blue)), backgroundColor: Colors.blue.withOpacity(0.1))).toList()),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(onPressed: () => launch(mapUrl), icon: const Icon(Icons.map, color: Colors.white), label: const Text('View on Map', style: TextStyle(color: Colors.black)), style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                  ),
                  const SizedBox(height: 30),
                  _buildRatingSection(),
                  const SizedBox(height: 30),
                  const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildCommentsSection(blogNo),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(child: TextField(controller: _commentController, decoration: const InputDecoration(hintText: 'Add a comment...'))),
                        IconButton(icon: const Icon(Icons.send), onPressed: () => _addComment(_commentController.text)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.2), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Average Rating:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text(_averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(width: 5),
              const Icon(Icons.star, color: Colors.blue, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(5, (index) {
              final stars = 5 - index;
              final progress = _ratingsDistribution[index] / (_ratingsDistribution.reduce((a, b) => a + b) + 1e-9); // Avoid divide by zero
              return Row(
                children: [
                  Text("$stars stars", style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Expanded(child: LinearProgressIndicator(value: progress, color: Colors.blue, backgroundColor: Colors.blue.shade100)),
                  const SizedBox(width: 5),
                  Text(_ratingsDistribution[index].toString(), style: const TextStyle(fontSize: 14)),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text('Rate this Post:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: _userRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) => _submitRating(rating),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(String blogId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('post').doc(blogId).collection('comments').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final comments = snapshot.data!.docs;
        if (comments.isEmpty) {
          return const Text('No comments yet.', style: TextStyle(color: Colors.grey));
        }

        return Column(
          children: comments.map((comment) {
            final data = comment.data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(data['userImage'] ?? 'https://i.postimg.cc/v859Vynv/download-1.png')),
              title: Text(data['userEmail'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['comment'], style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 5),
                  Text(data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate().toString() : 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
