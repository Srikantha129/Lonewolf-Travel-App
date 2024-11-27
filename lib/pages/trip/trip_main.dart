import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/places/place.dart';
import 'package:lonewolf/pages/places/recommended.dart';
import 'package:lonewolf/pages/trip/must_visit_place.dart';
import 'package:lonewolf/widget/carousel_pro/lib/carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/JourneyEntry.dart';
import '../../models/constants.dart';
import '../../screens/optimized_route_map.dart';

class TripMain extends StatefulWidget {
  final String randomString;

  const TripMain({super.key, required this.randomString});

  @override
  _TripMainState createState() => _TripMainState();
}

class _TripMainState extends State<TripMain> {
  List<JourneyEntry> userJourneys = [];
  String? userEmail;
  JourneyEntry? startLocation;
  JourneyEntry? endLocation;
  List<LatLng> _routePoints = [];
  String selectedTransportMode = 'Driving'; // Default transport mode
  List<String> transportModes = ['Driving', 'Walking', 'Cycling']; // Transport modes
  JourneyEntry? defaultLocation;
  //List<LatLng> _routePoints = []; // Replace with actual polyline points
  List<Marker> _markers = []; // Replace with actual marker data


  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    await _fetchUserJourneys();
    await _setDefault();
  }
  /// Checks the login status and retrieves the user's email.
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });

  }

  Future<void> _setDefault() async {
    // Ensure userEmail is available before setting the default location
    if (userEmail != null) {
      defaultLocation = JourneyEntry(
        displayName: "Katunayaka Airport",
        city: "Katunayaka",
        photoUrls: ["default_airport_image_url"],
        userRating: 4.5,
        email: userEmail!,
        description: 'Default Location',
        openHours: '24/7',
        priceRange: 'free',
        latitude: 7.180647079982,
        longitude: 79.88409789244446,
        dayCount: 5,
      );

      // Set startLocation and endLocation to default if not selected by the user
      setState(() {
        startLocation ??= defaultLocation;
        endLocation ??= defaultLocation;
      });
    }
  }

  /// Fetches journeys from Firestore where `randomString` matches.
  Future<void> _fetchUserJourneys() async {
    if (userEmail != null) {
      // Query Firestore to get the document where the document ID is widget.randomString
      final docSnapshot = await FirebaseFirestore.instance
          .collection('personaljourneys')
          .doc(widget.randomString) // Use the randomString as the document ID
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        List<JourneyEntry> matchedJourneys = [];
        List<dynamic> entries = docSnapshot['entries'] as List<dynamic>;

        // Iterate through each entry in the document's 'entries' field
        for (var entry in entries) {
          // Add each entry to matchedJourneys
          matchedJourneys.add(JourneyEntry.fromFirestore(entry as Map<String, dynamic>));
        }

        setState(() {
          userJourneys = matchedJourneys;
        });
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Trips', style: appBarTextStyle),
      ),
      body: ListView(
        children: [
          // Slider Start
         // slider(),
          // Slider End
          heightSpace,
          heightSpace,
          // Must Visit Start
          mustVisit(),
          // Must Visit End
          heightSpace,
          heightSpace,
          // Popular Destination Strat
          //popularDestination(),
          // Popular Destination End
          // Recommended Start
          Recommended(),
          // Recommended End
        ],
      ),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 230.0,
      width: width,
      child: Carousel(
        images: [
          ExactAssetImage('assets/trips/mount-fuji.jpg'),
          ExactAssetImage('assets/trips/swiss-alps.jpg'),
          ExactAssetImage('assets/trips/grand-teton.jpg'),
        ],
        dotSize: 6.0,
        dotSpacing: 18.0,
        dotColor: primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white,
        overlayShadowSize: 0.7,
      ),
    );
  }

  Widget mustVisit() {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Text('Your Travel Destinations', style: blackHeadingTextStyle),
          ),
          heightSpace,

          // List of travel destinations
          SizedBox(
            width: width,
            height: 340.0,
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
                          Icon(Icons.star, color: Colors.lime[600], size: 16.0),
                          const SizedBox(width: 5.0),
                          Text(journey.userRating.toString(), style: blackSmallTextStyle),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        journey.displayName,
                        style: blackBigTextStyle,
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
          heightSpace,
          heightSpace,

          // Dropdowns for Start and End Location selection
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start Location
                Text('Select Start Location:', style: blackSmallTextStyle),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<JourneyEntry>(
                    isExpanded: true,
                    value: startLocation,
                    hint: Text('Select Start Location'),
                    underline: SizedBox(),
                    onChanged: (JourneyEntry? newValue) {
                      setState(() {
                        startLocation = newValue;
                      });
                    },
                    items: [
                      // Default Location Option
                      DropdownMenuItem<JourneyEntry>(
                        value: defaultLocation,
                        child: Text("Default Location (Katunayaka Airport)"),
                      ),
                      ...userJourneys.map<DropdownMenuItem<JourneyEntry>>((JourneyEntry journey) {
                        return DropdownMenuItem<JourneyEntry>(
                          value: journey,
                          child: Text(journey.displayName),
                        );
                      }),
                    ],
                  ),
                ),
                heightSpace,

                // End Location
                Text('Select End Location:', style: blackSmallTextStyle),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<JourneyEntry>(
                    isExpanded: true,
                    value: endLocation,
                    hint: Text('Select End Location'),
                    underline: SizedBox(),
                    onChanged: (JourneyEntry? newValue) {
                      setState(() {
                        endLocation = newValue;
                      });
                    },
                    items: [
                      // Default Location Option
                      DropdownMenuItem<JourneyEntry>(
                        value: defaultLocation,
                        child: Text("Default Location (Katunayaka Airport)"),
                      ),
                      ...userJourneys.map<DropdownMenuItem<JourneyEntry>>((JourneyEntry journey) {
                        return DropdownMenuItem<JourneyEntry>(
                          value: journey,
                          child: Text(journey.displayName),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          heightSpace,
          heightSpace,

          // Dropdown to select transport mode
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: DropdownButton<String>(
              value: selectedTransportMode,
              onChanged: (newValue) {
                setState(() {
                  selectedTransportMode = newValue!;
                });
              },
              items: transportModes.map<DropdownMenuItem<String>>((String mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
            ),
          ),
          heightSpace,

          // Button to generate the optimal route
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: ElevatedButton(
              onPressed: startLocation != null && endLocation != null
                  ? () {
                generateOptimalRoute(
                );
              }
                  : null, // Disable if start or end location is not selected
              child: Text('Generate Optimal Route'),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> generateOptimalRoute() async {
    // Ensure required fields are set
    if (startLocation == null || endLocation == null) {
      print('Start and End locations are required');
      return;
    }

    // Construct the API request body
    final requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": startLocation!.latitude,
            "longitude": startLocation!.longitude,
          }
        },
        "sideOfRoad": true,
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": endLocation!.latitude,
            "longitude": endLocation!.longitude,
          }
        },
      },
      "intermediates": userJourneys.map((journey) {
        // Exclude start and end locations from intermediates
        if (journey == startLocation || journey == endLocation) return null;
        return {
          "location": {
            "latLng": {
              "latitude": journey.latitude,
              "longitude": journey.longitude,
            }
          }
        };
      }).where((entry) => entry != null).toList(),
      // Remove null entries
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      //"departureTime": DateTime.now().toUtc().toIso8601String(),
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": true,
        "avoidHighways": false,
        "avoidFerries": false,
      },
      "optimizeWaypointOrder": true,
      // Enables optimization of intermediate waypoints
      "languageCode": "en-US",
      "units": "IMPERIAL",
    };

    // Add your Google API Key here
    const String apiKey = googlePlacesApiKey;

    // Make the POST request
    final url = Uri.parse(
        'https://routes.googleapis.com/directions/v2:computeRoutes');
    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask":
      "routes.duration,routes.distanceMeters,routes.legs,routes.optimizedIntermediateWaypointIndex",
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        //debugPrint("Response Data: ${response.body}", wrapWidth: 10000);


        // Parse the response
        final responseData = jsonDecode(response.body);
        final routes = responseData['routes'];
        if (routes == null || routes.isEmpty) {
          print("No routes found in the response.");
          return;
        }

        // response data is already parsed into a map (data)
        String durationString = responseData['routes'][0]['duration'].toString(); // Ensure it's a string
        String distanceString = responseData['routes'][0]['distanceMeters'].toString(); // Ensure it's a string

        // Remove the 's' character from the duration string, if present
        durationString = durationString.replaceAll(RegExp(r'[^0-9]'), ''); // Removes any non-digit characters

        // Convert the strings to integers
        int durationInSeconds = int.parse(durationString);
        int distanceInMeters = int.parse(distanceString);

        // Convert duration from seconds to hours and minutes
        int hours = durationInSeconds ~/ 3600; // Divide by 3600 to get hours
        int minutes = (durationInSeconds % 3600) ~/ 60; // Get remaining minutes

        // Convert distance from meters to kilometers
        double distanceInKm = distanceInMeters / 1000.0; // Convert meters to kilometers

        // Print the formatted output
        print("Duration: $hours hours and $minutes minutes");
        print("Distance: ${distanceInKm.toStringAsFixed(2)} km");


        // Initialize an empty list for route points (polylines for all legs)
        List<LatLng> allRoutePoints = [];

        // Loop through the legs of the first route and add polylines for each leg
        final legs = routes[0]['legs'];
        if (legs != null) {
          for (var leg in legs) {
            final polyline = leg['polyline']['encodedPolyline'];
            if (polyline != null) {
              allRoutePoints.addAll(decodePolyline(polyline));  // Add the decoded points of this leg
            }
          }
        }

        // Now we have all the route points (start -> waypoints -> end)
        final markers = [
          Marker(
            markerId: const MarkerId('start'),
            position: LatLng(startLocation!.latitude, startLocation!.longitude),
            infoWindow: const InfoWindow(title: 'Start Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            // Start point in green
          ),
          Marker(
            markerId: const MarkerId('end'),
            position: LatLng(endLocation!.latitude, endLocation!.longitude),
            infoWindow: const InfoWindow(title: 'End Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // End point in red
          ),
        ];

        final optimizedOrder = routes[0]['optimizedIntermediateWaypointIndex'];
// Add intermediate markers in the correct order
        if (optimizedOrder != null) {
          for (int i = 0; i < optimizedOrder.length; i++) {
            final index = optimizedOrder[i];
            final journey = userJourneys[index];
            markers.add(
              Marker(
                markerId: MarkerId('waypoint_$i'),
                position: LatLng(journey.latitude, journey.longitude),
                infoWindow: InfoWindow(title: '${i + 1}. ${journey.displayName}'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                // Waypoints in blue
              ),
            );
          }
        }

        // Generate Google Maps URL
        final googleMapsUrl = generateGoogleMapsUrl(optimizedOrder);

        print("Google Maps URL: $googleMapsUrl");

        // Navigate to map with the route points and markers
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OptimizedRouteMapPage(
              routePoints: allRoutePoints,
              markers: markers,
            ),
          ),
        );
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
}


// function to decode the polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }


// Function to generate the Google Maps URL
  String generateGoogleMapsUrl(List<dynamic> optimizedOrder) {
    // Start and end locations as latitude, longitude
    final start = LatLng(startLocation!.latitude, startLocation!.longitude);
    final end = LatLng(endLocation!.latitude, endLocation!.longitude);

    // Construct waypoints in the optimized order
    final waypoints = <String>[];

    if (optimizedOrder != null) {
      for (var index in optimizedOrder) {
        final journey = userJourneys[index];
        final waypoint = '${journey.latitude},${journey.longitude}';
        waypoints.add(waypoint);
      }
    }

    // Create the Google Maps URL
    final waypointsParam = waypoints.isNotEmpty ? '&waypoints=${waypoints.join('|')}' : '';
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}$waypointsParam';

    return googleMapsUrl;
  }




/* popularDestination() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: fixPadding * 2.0, left: fixPadding * 2.0),
          child: Text('Popular Destination', style: blackHeadingTextStyle),
        ),
        heightSpace,
        heightSpace,
        Container(
          width: width,
          height: 200.0,
          child: ListView.builder(
            itemCount: popularDestinationList.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = popularDestinationList[index];
              *//*return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 1000),
                          child: Place(
                              title: item['name'], images: item['image'])));
                },
                child: Container(
                  width: 150.0,
                  margin: (index == popularDestinationList.length - 1)
                      ? EdgeInsets.only(
                          left: fixPadding * 2.0, right: fixPadding * 2.0)
                      : EdgeInsets.only(left: fixPadding * 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 180.0,
                        height: 150.0,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      heightSpace,
                      Container(
                        width: 180.0,
                        alignment: Alignment.center,
                        child: Text(
                          item['name']!,
                          style: blackBigTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              );*//*
            },
          ),
        ),
      ],
    );
  }*/
}
