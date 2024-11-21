import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this for better typography
import 'package:lonewolf/screens/personalize_route.dart';
import 'package:lonewolf/screens/view_personalize_route.dart';
import 'package:lonewolf/services/journey_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant.dart';
import '../models/LoneWolfUser.dart';
import 'blog_page.dart';
import 'explore.dart';
import 'package:lonewolf/pages/home/home.dart';

class HomePage extends StatefulWidget {
  //final User loggedUser;
  const HomePage({/*required this.loggedUser,*/ super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LoneWolfUser? user;
  String? userEmail;

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
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkLoginStatus();
    if (userEmail != null) {
      await _fetchUser(userEmail!);
    } else {
      print('User email is null. Cannot fetch user.');
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _fetchUser(String email) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (docSnapshot.size > 0) {
        setState(() {
          user = LoneWolfUser.fromJson(docSnapshot.docs.first.data());
        });
      } else {
        print('No user found with email: $email');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        /*flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),*/
        centerTitle: true,
        title: Image.asset(
          'assets/images/Logo1.png',
          height: 40.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewPersonalizeRoute(/*loggedUser: widget.loggedUser*/),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: _auth.signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final posts = snapshot.data!;
                return Column(
                  children: posts
                      .map((post) => _buildBlogCard(post,context))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching posts: ${snapshot.error}'),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00B4DB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Plan Your Adventure',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'New',
          ),
        ],
        currentIndex: 0,
        onTap: (int index) async {
          switch (index) {
            case 1:
              bool journeyExists = await JourneyDbService()
                  .isExistsByEmail(userEmail!);

              if (journeyExists) {
                _showDeleteDialog();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalizeRoute(*//*loggedUser: widget.loggedUser*//*),
                  ),
                );
              }
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExplorePage(),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homne(),
                ),
              );
              break;
          }
        },
      ),*/
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> post, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPage(
                blogId: post['id'],
                /*loggedUser: widget.loggedUser,*/
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    post['photoUrl1'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        post['hashtag1'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      post['shortDescription'],
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Current Journey?'),
        content: const Text('This action is irreversible. Proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await JourneyDbService()
                  .deleteJourneyByEmail(userEmail!);
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PersonalizeRoute(/*loggedUser: widget.loggedUser*/),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }*/
}
