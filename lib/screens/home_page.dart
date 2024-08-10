

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/LoneWolfUser.dart';
import 'blog_page.dart';
import 'explore.dart';


class HomePage extends StatefulWidget {
  final User loggedUser;
  const HomePage({required this.loggedUser, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LoneWolfUser? user;

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final querySnapshot = await _firestore.collection('post').get();
    final documents = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
    return documents;
  }

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
    final currentUser = widget.loggedUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/Logo1.png',
          height: 30.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _auth.signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final posts = snapshot.data!;
                return Column(
                  children: posts
                      .map((post) => _buildBlogCard(post, context))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching posts: ${snapshot.error}'),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
              // return Column(
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => BlogPage(
              //               blogId: "IamIgfW1t8RonVH6taVh",
              //               loggedUser: currentUser,
              //             ),
              //           ),
              //         );
              //       },
              //       child: Card(
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5.0),
              //         ),
              //         color: Colors.grey[100],
              //         elevation: 2.0,
              //         child: Column(
              //           children: [
              //             Image.asset(
              //               'assets/images/sigiriya1.jpg',
              //               fit: BoxFit.cover,
              //               height: 300.0,
              //               width: double.infinity,
              //             ),
              //             Container(
              //               padding: const EdgeInsets.all(10.0),
              //               child: const Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Sri Lanka\'s Lion Rock Fortress Unveiled',
              //                     style: TextStyle(
              //                         fontSize: 16.0,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                   SizedBox(height: 5.0),
              //                   Text(
              //                     'Sigiriya, also known as the "Lion Rock," is a breathtaking historical and archaeological marvel nestled in the heart of Sri Lanka. This UNESCO World Heritage Site boasts a unique combination of nature, culture, and history, captivating travelers worldwide.',
              //                     style: TextStyle(
              //                         fontSize: 14.0, color: Colors.black54),
              //                   ),
              //                   SizedBox(height: 5.0),
              //                   Row(
              //                     children: [
              //                       Text(
              //                         '#hashtag1',
              //                         style: TextStyle(
              //                             fontSize: 12.0, color: Colors.blue),
              //                       ),
              //                       SizedBox(width: 5.0),
              //                       Text(
              //                         '#hashtag2',
              //                         style: TextStyle(
              //                             fontSize: 12.0, color: Colors.blue),
              //                       ),
              //                       SizedBox(width: 5.0),
              //                       Text(
              //                         '#hashtag3',
              //                         style: TextStyle(
              //                             fontSize: 12.0, color: Colors.blue),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context, // Current context
              //       MaterialPageRoute(
              //         builder: (context) => const BlogPage(blogNo: 2,),
              //       ),
              //     );
              //   },
              //   child: Card(
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //     color: Colors.grey[100],
              //     elevation: 2.0,
              //     child: Column(
              //       children: [
              //         // Image content
              //         Image.asset(
              //           'assets/images/ninearch1.jpg',
              //           fit: BoxFit.cover,
              //           height: 300.0,
              //           width: double.infinity,
              //         ),
              //         Container(
              //           padding: const EdgeInsets.all(10.0), // Add some padding
              //           child: const Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Bridge in the Sky - Nine Arch',
              //                 style: TextStyle(
              //                     fontSize: 16.0, fontWeight: FontWeight.bold),
              //               ),
              //               SizedBox(height: 5.0),
              //               Text(
              //                 '''Nestled amidst the verdant hills of Sri Lanka's central highlands lies a marvel of colonial-era engineering - the Nine Arch Bridge. Often referred to as the "Bridge in the Sky," this awe-inspiring structure gracefully arches over a deep valley, captivating travelers with its unique design and rich history.''',
              //                 style: TextStyle(
              //                     fontSize: 14.0, color: Colors.black54),
              //               ),
              //               SizedBox(height: 5.0),
              //               Row(
              //                 children: [
              //                   Text(
              //                     '#hashtag1',
              //                     style: TextStyle(
              //                         fontSize: 12.0, color: Colors.blue),
              //                   ),
              //                   SizedBox(width: 5.0),
              //                   Text(
              //                     '#hashtag2',
              //                     style: TextStyle(
              //                         fontSize: 12.0, color: Colors.blue),
              //                   ),
              //                   SizedBox(width: 5.0),
              //                   Text(
              //                     '#hashtag3',
              //                     style: TextStyle(
              //                         fontSize: 12.0, color: Colors.blue),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //   ],
              // );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        currentIndex: 0,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExplorePage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> post, BuildContext context) {
    final String title = post['title'];
    final String shortDescription = post['shortDescription'];
    final String hashtag1 = post['hashtag1'];
    final String hashtag2 = post['hashtag2'];
    final String hashtag3 = post['hashtag3'];
    final String photoUrl1 = post['photoUrl1'];
    //final String photoUrl2 = post['photoUrl2'];
    //final String photoUrl3 = post['photoUrl3'];
   // final String photoUrl4 = post['photoUrl4'];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogPage(
              blogId: post['id'],
              loggedUser: widget.loggedUser,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.grey[100],
        elevation: 2.0,
        child: Column(
          children: [
            Image.asset(
              photoUrl1,
              fit: BoxFit.cover,
              height: 300.0,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    shortDescription,
                    style:
                        const TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        hashtag1,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        hashtag2,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        hashtag3,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
