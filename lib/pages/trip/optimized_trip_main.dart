import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lonewolf/models/JourneyEntry.dart';
import 'package:lonewolf/screens/optimized_route_map.dart';
import 'package:lonewolf/constant/constant.dart';

class OptimizedTripMain extends StatefulWidget {
  final String randomString;
  final List<LatLng> routePoints;
  final List<Marker> markers;
  final double fare;
  final String transportMode;
  final int hours;
  final int minutes;
  final double distance;

  const OptimizedTripMain({
    super.key,
    required this.randomString,
    required this.routePoints,
    required this.markers,
    required this.fare,
    required this.transportMode,
    required this.hours,
    required this.minutes,
    required this.distance,
  });

  @override
  State<OptimizedTripMain> createState() => _OptimizedTripMainState();
}

class _OptimizedTripMainState extends State<OptimizedTripMain> {
  List<JourneyEntry> userJourneys = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    await _fetchUserJourneys();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _fetchUserJourneys() async {
    if (userEmail != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('personaljourneys')
          .doc(widget.randomString)
          .get();

      if (docSnapshot.exists) {
        List<dynamic> entries = docSnapshot['entries'] as List<dynamic>;
        setState(() {
          userJourneys = entries
              .map((entry) => JourneyEntry.fromFirestore(entry as Map<String, dynamic>))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double budget = 0.0;
    for (var journey in userJourneys) {
      if (journey.priceRange.isNotEmpty) {
        List<String> priceParts = journey.priceRange.split(' - ');
        if (priceParts.length == 2) {
          try {
            double lowerPrice = double.parse(priceParts[0].replaceAll(RegExp(r'[^0-9.]'), ''));
            double upperPrice = double.parse(priceParts[1].replaceAll(RegExp(r'[^0-9.]'), ''));
            budget += (lowerPrice + upperPrice) / 2;
          } catch (e) {
            debugPrint('Error parsing price range: ${journey.priceRange}');
          }
        }
      }
    }
    double totalBudget = budget + widget.fare;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Trip',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.withOpacity(0.7), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Summary Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryItem('Pre-Travel Estimated Budget', '\$${budget.toStringAsFixed(2)}'),
                  _buildSummaryItem('Vehicle Fare', '\$${widget.fare.toStringAsFixed(2)}'),
                  _buildSummaryItem('Total Estimated Budget', '\$${totalBudget.toStringAsFixed(2)}'),
                  _buildSummaryItem('Preferred Travel Mode', widget.transportMode),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      Text('${widget.hours} hrs ${widget.minutes} mins'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.map, color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      Text('${widget.distance.toStringAsFixed(2)} km'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Travel Destinations Section
            Text(
              'Your Travel Destinations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 340,
              child: ListView.builder(
                itemCount: userJourneys.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final journey = userJourneys[index];
                  return Container(
                    width: 150.0,
                    margin: (index == userJourneys.length - 1)
                        ? EdgeInsets.symmetric(horizontal: fixPadding * 2.0)
                        : EdgeInsets.only(left: fixPadding * 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: journey.displayName,
                          child: Container(
                            width: 150.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    journey.photoUrls.isNotEmpty
                                        ? journey.photoUrls.first
                                        : 'default_image_url'), // Fallback image
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        heightSpace,
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow[700], size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(journey.userRating.toString(), style: blackSmallTextStyle),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          journey.displayName,
                          style: blackBigTextStyle.copyWith(color: Colors.teal),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: greyColor, size: 18.0),
                            Text(journey.city, style: greySmallTextStyle),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Optimal Route Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OptimizedRouteMapPage(
                      routePoints: widget.routePoints,
                      markers: widget.markers,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              icon: const Icon(Icons.directions, color: Colors.white),
              label: const Text(
                'View Optimal Route',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
        ],
      ),
    );
  }
}
