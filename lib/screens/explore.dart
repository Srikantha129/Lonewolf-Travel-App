import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lonewolf/screens/personalize_route.dart';
import 'package:lonewolf/screens/province_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Province.dart';
import '../services/journey_db_service.dart';

class ExplorePage extends StatefulWidget {
  // final User loggedUser;
  const ExplorePage({super.key, /*required this.loggedUser*/});

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  List<Province> provinces = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchProvinces();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      // displayName = prefs.getString('userName');
      // print('received photoUrl: $photoURL');
    });
  }
  void _fetchProvinces() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('provinze').get();
    setState(() {
      provinces =
          snapshot.docs.map((doc) => Province.fromDocument(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Sri Lanka'),
      ),
      body: provinces.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemCount: provinces.length,
              itemBuilder: (context, index) {
                final province = provinces[index];
                return InkWell(
                  onTap: () {
                    // Navigate to the province details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProvinceDetailsPage(province: province.name),
                      ),
                    );
                  },
                  child: CityCard(
                    cityName: province.name,
                    cityImage: province.imageUrl,
                    provinceDescription: province.description,
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10.0),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        ],
        currentIndex: 0,
        onTap: (int index) async {
          switch (index) {
            case 0:
              break;
            case 1:
              if (await JourneyDbService()
                  .isExistsByEmail(userEmail!)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          const Text('Your Current Journey will be Deleted !!'),
                      content: const Text('Are you sure you want to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await JourneyDbService().deleteJourneyByEmail(
                              userEmail!);
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PersonalizeRoute(
                                      /*loggedUser: widget.loggedUser*/)),
                            );
                          },
                          child: const Text('Proceed'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PersonalizeRoute(/*loggedUser: widget.loggedUser*/)),
                );
              }
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final String cityName;
  final String cityImage;
  final String provinceDescription;

  const CityCard(
      {Key? key,
      required this.cityName,
      required this.cityImage,
      required this.provinceDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("City Image URL: $cityImage");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3.0,
              blurRadius: 5.0)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            // Background city image
            /*Image.network(
              cityImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300.0, // Adjust height as needed
            ),*/

            Image.asset(
              cityImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300.0,
              // loadingBuilder: (context, loadingProgress, error) {
              //   if (error != null) {
              //     return const Icon(Icons.error);
              //   }
              //   return Center(child: CircularProgressIndicator(value: loadingProgress?.downloaded / loadingProgress?.total));
              // },
            ),

            // Text with location name - centered
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Text(
                cityName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 2.0)
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Bottom white content area
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName, // Replace with a more descriptive title
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5.0),
                    // Text with content related to the province (replace with your data)
                    Text(provinceDescription),
                    const SizedBox(height: 5.0),
                    // Downward pointing triangle (optional) - using ClipPath
                    /*Align(
                      alignment: Alignment.bottomRight,
                      child: ClipPath(
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          color: Colors.grey[400],
                        ),
                        clipper: CustomTriangleClipper(),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
