/*
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lonewolf/models/travel_locations.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:lonewolf/models/Location.dart';
import 'package:lonewolf/screens/view_personalize_route.dart';
import 'package:lonewolf/services/journey_db_service.dart';
import 'package:lonewolf/services/location_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lonewolf/models/JourneyEntry.dart';
import 'package:lonewolf/services/personal_journey_db_service.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/loading_anime.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fetching your personalized locations...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectPersonalizeRoute extends StatefulWidget {
  final List<TravelLocation> place;

  const SelectPersonalizeRoute({
    super.key,
    required this.place,
  });

  @override
  State<SelectPersonalizeRoute> createState() => _SelectPersonalizeRouteState();
}

class _SelectPersonalizeRouteState extends State<SelectPersonalizeRoute> {
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocationDbService _locationDbService = LocationDbService();
  List<JourneyLocation> locations = [];
  String? _selectedDay = '01';
  Stream? _userJourney;
  List<DropdownMenuItem<String>> _dayItems = [];
  String? userEmail;
  int dayCount = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchData();
    _logPlaceDetails();
    debugPrint('Places length: ${widget.place.length}');
  }

  /// Checks the login status and retrieves the user's email.
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  /// Logs details of the places passed to this widget.
  void _logPlaceDetails() {
    for (var place in widget.place) {
      debugPrint('Place name: ${place.displayName}');
    }
  }

  /// Fetches journey and location data from the database.
  Future<void> _fetchData() async {
    locations = await _locationDbService.getLocations();
    _userJourney = JourneyDbService().getJourneysByEmail(userEmail!);

    _userJourney?.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final journey = snapshot.docs.first.data();
        final dateDifference =
            journey.endDate.difference(journey.startDate).inDays;

        setState(() {
          _dayItems = _generateDayItems(dateDifference);
          dayCount = dateDifference;
          _isLoading = false;
        });
      }
    });
  }

  /// Generates dropdown items for selecting days based on the journey duration.
  List<DropdownMenuItem<String>> _generateDayItems(int dateDifference) {
    return List<DropdownMenuItem<String>>.generate(
      dateDifference,
          (index) {
        final day = (index + 1).toString().padLeft(2, '0');
        return DropdownMenuItem<String>(
          value: day,
          child: Text(day),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/Logo1.png',
          height: 30.0,
        ),
        backgroundColor: const Color(0xFF00B4DB),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPersonalizeRoute(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await _auth.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // ListView of places
          Positioned.fill(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: widget.place.length,
              itemBuilder: (context, index) {
                final place = widget.place[index];
                final imageSource = (place.photoUrls.isNotEmpty)
                    ? place.photoUrls[0]
                    : 'https://i.postimg.cc/hPZQ23q6/default-image.jpg';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 8.0,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          imageSource,
                          height: 250.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.displayName,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text('Which day to visit?  '),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: _selectedDay,
                                  items: _dayItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDay = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 10.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Add to Trip'),
                                onPressed: () {
                                  final journeyEntry = JourneyEntry(
                                    day: _selectedDay ?? '01',
                                    email: userEmail ?? 'default@example.com',
                                    description:
                                    place.description,
                                    city: place.city,
                                    openHours: place.openHours,
                                    priceRange: place.priceRange,
                                    userRating: place.userRating,
                                    latitude: place.latitude,
                                    longitude: place.longitude,
                                    photoUrls: place.photoUrls,
                                    dayCount: dayCount,
                                    locationName: place.displayName,
                                  );

                                  PersonalJourneyService().addJourney(
                                      userEmail!,
                                      journeyEntry.toFirestore());

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${place.displayName} added to your trip!'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Button to generate optimized route
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Generate Optimize Route',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              onPressed: () =>
                  launch('https://maps.app.goo.gl/PWhYGEJzFYHqXM5b6'),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/hotel/hotel_room.dart';
import 'package:lonewolf/widget/column_builder.dart';

import 'package:lonewolf/models/travel_locations.dart';

import 'location_details.dart';

class SelectPersonalizeRoute extends StatelessWidget {
  final List<TravelLocation> place;
  final String randomString;

  const SelectPersonalizeRoute({super.key, required this.place,required this.randomString,});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final recommendedList = place.toList(); // Use the entire list

    return WillPopScope(
        onWillPop: () async {
      // Show confirmation dialog
      bool? confirmExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to leave this page?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Dismiss and return false
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Dismiss and return true
              child: const Text("Yes"),
            ),
          ],
        ),
      );
      return confirmExit ?? false; // If null (dialog dismissed), prevent exit
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Personalized Route"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*const Text(
              'Personalized Route',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),*/
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recommendedList.length,
                itemBuilder: (context, index) {
                  final item = recommendedList[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 700),
                            type: PageTransitionType.fade,
                            child: LocationDetails(
                              // title: item.name,
                              // imgPath: item.photoUrls?.first, // Placeholder for image URL
                              //   price: '\$${item.avDates?.first.values.first ?? 'N/A'}',// Access the price from the first map in avDates
                              place: item, randomString:randomString
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: width - 40,
                        margin: EdgeInsets.only(
                          top: (index != 0) ? 20 : 0.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: item.displayName,
                              child: Container(
                                width: double.infinity,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(item.photoUrls.first), // Using NetworkImage directly
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.displayName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          children: [
                                            ratingBar(item.userRating),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              '(${item.userRating})',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              item.city,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.priceRange,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5.0),
                                        const Text(
                                          'per ticket',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
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
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Star rating widget
  Widget ratingBar(double number) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < number ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
        );
      }),
    );
  }

  // Image provider with fallback to network image
  ImageProvider _getImageProvider(String imageUrl) {
    try {
      return AssetImage(imageUrl);
    } catch (_) {
      return NetworkImage(imageUrl);
    }
  }
}