import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lonewolf/pages/places/recommended_for_route.dart';
import 'package:lonewolf/pages/trip/optimized_trip_main.dart';
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

import 'dart:io'; // For File operations
import 'package:path_provider/path_provider.dart'; // For getting directory paths

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
  String selectedTransportMode = 'Public'; // Default transport mode
  List<String> transportModes = ['Public', 'Tuk Tuk']; // Transport modes
  JourneyEntry? defaultLocation;
  //List<LatLng> _routePoints = []; // Replace with actual polyline points
  //List<Marker> _markers = []; // Replace with actual marker data


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
          .doc(userEmail) // Use the randomString as the document ID
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
          const RecommendedForRoute(),
          // Recommended End
        ],
      ),
    );
  }


 /* Widget mustVisit() {
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
  }*/
  Widget mustVisit() {
    double width = MediaQuery.of(context).size.width;

    double totalBudget = 0.0; // Variable to store the total budget

    // Calculate the total budget by adding the median of the price ranges
    for (var journey in userJourneys) {
      if (journey.priceRange.isNotEmpty) {
        // Extracting price range (e.g., "$5 - $10")
        List<String> priceParts = journey.priceRange.split(' - ');
        if (priceParts.length == 2) {
          try {
            // Print the price range for debugging
            //print('Processing journey: ${journey.displayName}');
            //print('Price Range: ${journey.priceRange}');
            // Parse the lower and upper bounds of the price range
            double lowerPrice = double.parse(priceParts[0].replaceAll(RegExp(r'[^0-9.]'), ''));
            double upperPrice = double.parse(priceParts[1].replaceAll(RegExp(r'[^0-9.]'), ''));

            // Calculate the median price
            double medianPrice = (lowerPrice + upperPrice) / 2;



            // Print the parsed prices and the median for debugging
            //print('Lower Price: $lowerPrice, Upper Price: $upperPrice');
            //print('Median Price: $medianPrice');
            // Add the median price to the total budget
            totalBudget += medianPrice;
          } catch (e) {
            // Handle any parsing errors if the price range is not in the expected format
            print('Error parsing price range: ${journey.priceRange}');
          }
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading with a travel-related icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Row(
              children: [
                const Icon(Icons.airplanemode_active, color: Colors.orange, size: 28.0), // Travel icon
                const SizedBox(width: 8.0),
                Text('Your Travel Destinations', style: blackHeadingTextStyle.copyWith(color: Colors.teal)),
              ],
            ),
          ),
          heightSpace,
          heightSpace,

          // Total Budget Display with a soft background
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pre-Travel Estimated Budget: \$${totalBudget.toStringAsFixed(2)}',
                    style: blackBigTextStyle.copyWith(color: Colors.teal),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '(Excludes travel costs such as vehicle fees and transportation)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          heightSpace,
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
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0), // Ensures rounded corners for the image
                            child: Image.network(
                              journey.photoUrls.isNotEmpty
                                  ? journey.photoUrls.first
                                  : 'default_image_url', // Default URL if no photos available
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to an AssetImage if the NetworkImage fails
                                return Image.asset(
                                  journey.photoUrls.isNotEmpty
                                      ? journey.photoUrls.first
                                      : 'default_image_url', // Replace with your fallback image path
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<JourneyEntry>(
                    isExpanded: true,
                    value: startLocation,
                    hint: const Text('Select Start Location'),
                    underline: const SizedBox(),
                    onChanged: (JourneyEntry? newValue) {
                      setState(() {
                        startLocation = newValue;
                      });
                    },
                    items: [
                      // Default Location Option
                      DropdownMenuItem<JourneyEntry>(
                        value: defaultLocation,
                        child: const Text("Default Location (Katunayaka Airport)"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<JourneyEntry>(
                    isExpanded: true,
                    value: endLocation,
                    hint: const Text('Select End Location'),
                    underline: const SizedBox(),
                    onChanged: (JourneyEntry? newValue) {
                      setState(() {
                        endLocation = newValue;
                      });
                    },
                    items: [
                      // Default Location Option
                      DropdownMenuItem<JourneyEntry>(
                        value: defaultLocation,
                        child: const Text("Default Location (Katunayaka Airport)"),
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
                generateOptimalRoute();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0), // Increased padding for a larger button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // More rounded corners for a modern look
                ),
                minimumSize: const Size(double.infinity, 55), // Ensures the button takes up full width and has a sufficient height
              ), // Disable if start or end location is not selected
              child: const Text(
                'Generate Optimal Route',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0, // Increase font size for better readability
                ),
              ),
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
      "routes.duration,routes.distanceMeters,routes.legs,routes.optimizedIntermediateWaypointIndex,routes.warnings",
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
        //await saveJsonToFile(responseData, 'routes.json');
        final warnings = responseData['routes']?[0]['warnings'];

        // Print the warnings if they exist
        if (warnings != null && warnings.isNotEmpty) {
          print("Warnings:");
          for (var warning in warnings) {
            print(warning);
          }
        } else {
          print("No warnings found.");
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

        // Fare calculation
        const double lkrToUsd = 295.0;
        double fareInUSD = 0.0;

        if (selectedTransportMode == 'Tuk Tuk') {
          double ratePerKm;
          if (distanceInKm <= 200) {
            ratePerKm = 50.0;
          } else if (distanceInKm <= 300) {
            ratePerKm = 48.0;
          } else if (distanceInKm <= 500) {
            ratePerKm = 46.0;
          } else if (distanceInKm <= 800) {
            ratePerKm = 43.0;
          } else {
            ratePerKm = 40.0;
          }
          double fareInLKR = distanceInKm * ratePerKm;
          fareInUSD = fareInLKR / lkrToUsd;
        } else if (selectedTransportMode == 'Public') {
          const double farePerKmLKR = 4.0;
          double fareInLKR = distanceInKm * farePerKmLKR;
          fareInUSD = fareInLKR / lkrToUsd;
        }

        print("Fare for $selectedTransportMode: USD ${fareInUSD.toStringAsFixed(2)}");

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

        // Save data to Firestore
       /* final routeDoc = FirebaseFirestore.instance.collection('optimal_route').doc();

        await routeDoc.set({
          'randomString': widget.randomString,
          'routeId': routeDoc.id,
          'email': userEmail,
          'allRoutePoints': allRoutePoints.map((point) => {
            'latitude': point.latitude,
            'longitude': point.longitude,
          }).toList(),
          'markers': markers.map((marker) => {
            'id': marker.markerId.value,
            'latitude': marker.position.latitude,
            'longitude': marker.position.longitude,
            'infoWindow': marker.infoWindow.title,
          }).toList(),
          'googleMapsUrl': googleMapsUrl,
          'hours':hours,
          'minutes': minutes,
          'distance': distanceInKm.toStringAsFixed(2),
        });*/
        // Navigate to map with the route points and markers
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OptimizedTripMain(
              routePoints: allRoutePoints,
              markers: markers,
              fare:fareInUSD,
              transportMode:selectedTransportMode,
              randomString: widget.randomString,
              hours:hours,
              minutes:minutes,
              distance:distanceInKm,
              warning: warnings,
              googleMapsUrl:googleMapsUrl,

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

 /* Future<void> saveJsonToFile(Map<String, dynamic> jsonData, String fileName) async {
    try {
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Convert JSON to string
      final jsonString = jsonEncode(jsonData);

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonString);

      print('File saved to: $filePath');
    } catch (e) {
      print('Error saving file: $e');
    }
  }*/
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
