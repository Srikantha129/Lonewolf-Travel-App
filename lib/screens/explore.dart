import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'province_details_page.dart';
import '../models/Province.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Province> provinces = [];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  void _fetchProvinces() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('provinze').get();
    setState(() {
      provinces = snapshot.docs.map((doc) => Province.fromDocument(doc)).toList();
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
                  builder: (context) => ProvinceDetailsPage(province: province.name),
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
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
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
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context); // Navigate back
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

  const CityCard({Key? key, required this.cityName, required this.cityImage, required this.provinceDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("City Image URL: $cityImage");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 3.0, blurRadius: 5.0)
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

            CachedNetworkImage(
              imageUrl: cityImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300.0,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Centered placeholder
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeOutDuration: Duration(milliseconds: 500), // Fade in animation
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
                    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2.0)
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
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
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
                      "$cityName", // Replace with a more descriptive title
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    // Text with content related to the province (replace with your data)
                    Text(provinceDescription),
                    SizedBox(height: 5.0),
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
