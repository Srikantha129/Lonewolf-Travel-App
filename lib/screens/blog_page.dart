import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:cached_network_image/cached_network_image.dart';

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
  LoneWolfUser? user;
  bool isFavourited = false;

  @override
  void initState() {
    super.initState();
    _fetchUser(widget.loggedUser.email!.toString());
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
      } else {
        print('User not found in Firestore');
      }
    } on FirebaseException catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogNo = widget.blogId;
    // final currentUser = widget.loggedUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              icon: isFavourited
                  ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
                  : const Icon(Icons.favorite_border_outlined)),
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
              final Map<String, dynamic> blogData =
              snapshot.data!.data() as Map<String, dynamic>;
              final title = blogData['title'] as String;
              final createdOn = blogData['createdOn'] as String;
              final fullDescription = blogData['fullDescription'] as String;
              final shortDescription = blogData['shortDescription'] as String;
              final hashtag1 = blogData['hashtag1'] as String;
              final hashtag2 = blogData['hashtag2'] as String;
              final hashtag3 = blogData['hashtag3'] as String;
              final photoUrl1 = blogData['photoUrl1'] as String;
              final photoUrl2 = blogData['photoUrl2'] as String;
              final photoUrl3 = blogData['photoUrl3'] as String;
              final photoUrl4 = blogData['photoUrl4'] as String;
              final List<String> imagePaths = [
                photoUrl1,
                photoUrl2,
                photoUrl3,
                photoUrl4
              ];
              final mapUrl = blogData['mapUrl'] as String;

              return Column(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          createdOn,
                          style: const TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.grey[100],
                        elevation: 2.0,
                        child: SizedBox(
                          height: 300.0,
                          child: PageView.builder(
                            itemCount: imagePaths.length,
                            itemBuilder: (context, index) {

                              return Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );

                             /* return CachedNetworkImage(
                                  imageUrl: imagePaths[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              );*/

                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5.0),
                            Text(
                              shortDescription,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              fullDescription,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            Row(
                              children: [
                                Text(
                                  hashtag1,
                                  style: const TextStyle(
                                      fontSize: 12.0, color: Colors.blue),
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  hashtag2,
                                  style: const TextStyle(
                                      fontSize: 12.0, color: Colors.blue),
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  hashtag3,
                                  style: const TextStyle(
                                      fontSize: 12.0, color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => launch(
                              mapUrl),
                          child: const Card(
                            color: Colors.grey,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  25.0), // Adjust padding as needed
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.flight_takeoff,
                                      color: Colors.white),
                                  Text(
                                    'Travel Guide',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'You might also like ',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => launchUrl(
                              Uri.parse('https://maps.app.goo.gl/PWhYGEJzFYHqXM5b6')),
                          child: const Card(
                            color: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  25.0), // Adjust padding as needed
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.flight_takeoff, color: Colors.white),
                                  Flexible( // Wrap the text
                                    child: Text(
                                      'Travel Guide',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: () {}, // Add your desired action here
                          child: const Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.flight_takeoff, color: Colors.white),
                                  Flexible(
                                    child: Text(
                                      'Travel Guide',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
