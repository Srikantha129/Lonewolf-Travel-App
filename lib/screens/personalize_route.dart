import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lonewolf/screens/select_personalize_route.dart';
import 'package:lonewolf/models/Journey.dart';
import 'package:lonewolf/services/journey_db_service.dart';
import 'package:lonewolf/screens/explore.dart';
import 'package:http/http.dart' as http;
import 'package:lonewolf/models/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/Preferences.dart';
import 'package:lonewolf/models/new_places.dart';

import '../models/travel_locations.dart';
import '../services/newplaces_db_service.dart';

class PersonalizeRoute extends StatefulWidget {
  //final User loggedUser;

  const PersonalizeRoute({
    super.key,
    //required this.loggedUser,
  });

  @override
  State<PersonalizeRoute> createState() => _PersonalizeRouteState();
}

class _PersonalizeRouteState extends State<PersonalizeRoute> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> selectedInterests = [];
  late List<TravelLocation> places;
  //List<PlacePhotos> placePhotosList = [];
  //List<PlacePhotos> placePhotoUrls = [];
  bool _isDisposed = false;
  String? userEmail;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    //fetchAndPrintCachedLocations();

  }
  @override
  void dispose() {
    _isDisposed = true;
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      // displayName = prefs.getString('userName');
      // print('received photoUrl: $photoURL');
    });
  }
/*  void fetchAndPrintCachedLocations() async {
    final cachedLocationDbService = CachedLocationDbService();

    try {
      // Fetch all cached locations
      List<CachedLocation> cachedLocations = await cachedLocationDbService.getCachedLocations();

      // Print each cached location's details
      for (var location in cachedLocations) {
        print('Main Preference: ${location.mainPreference ?? 'N/A'}');

        // Print secondary preferences if available
        if (location.secondaryPreferences != null && location.secondaryPreferences!.isNotEmpty) {
          print('Secondary Preferences: ${location.secondaryPreferences!.join(', ')}');
        } else {
          print('Secondary Preferences: N/A');
        }

        print('Places:');
        if (location.places != null && location.places!.isNotEmpty) {
          for (var place in location.places!) {
            print('  - Display Name: ${place.displayName?.text ?? 'N/A'}');
            print('    Address: ${place.formattedAddress ?? 'N/A'}');
            print('    Rating: ${place.rating ?? 'N/A'}'); // Uncomment this line if you want to include the rating
            print('    Location: Lat ${place.location.latitude}, Lng ${place.location.longitude}'); // Location is non-nullable
            if (place.photoUrls != null && place.photoUrls!.isNotEmpty) {
              print('    Photo URLs: ${place.photoUrls!.join(', ')}');
            }
            print('    Google Maps URI: ${place.googleMapsUri ?? 'N/A'}');
            print('    User Rating Count: ${place.userRatingCount ?? 'N/A'}');
          }
        } else {
          print('    No places available');
        }
        print('---');
      }
    } catch (e) {
      print('Error fetching cached locations: $e');
    }
  }*/


  List<String> mapInterestsToPlaceTypes(List<String> userInterests) {
    final subPlaceTypes = <String>[];
    for (var interest in userInterests) {
      print(interest);
      if (interestToPlaceTypes.containsKey(interest.replaceAll('#', ''))) {
        subPlaceTypes.addAll(interestToPlaceTypes[interest.replaceAll('#', '')]!);
      }
    }
    print('Final list of place types: $subPlaceTypes');
    return subPlaceTypes;
  }

  Future<List<String>> getMainPreferences(List<String> userInterests) async {
    final placeTypes = <String>[];

    for (var interest in userInterests) {
      // Remove the '#' symbol to match the document name
      final placeType = interest.replaceFirst('#', '');
      placeTypes.add(placeType);
    }

    return placeTypes;
  }



  Future<List<Place>> fetchLocationsFromFirestore(List<String> userPreferences) async {
    try {
      // Log user preferences to see what is being queried
      debugPrint("User preferences for fetching locations: $userPreferences");

      // Query cached_locations for matching preferences
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cached_locations')
          .where('mainPreferences', arrayContainsAny: userPreferences)
          .get();

      debugPrint("Query executed. Number of documents fetched: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        // Log each document's data to check the structure
        return querySnapshot.docs.map((doc) {
          try {
            final data = doc.data();
            debugPrint("Processing document: ${doc.id}");
            debugPrint("Document data: $data");

            // Check if any key in the document is null or has unexpected values
            data.forEach((key, value) {
              if (value == null) {
                debugPrint("Warning: Key '$key' has a null value in document ${doc.id}");
              }
            });

            return Place.fromJson(data);
          } catch (error) {
            debugPrint("Error mapping document ${doc.id} to Place: $error");
            debugPrint("Document data causing error: ${doc.data()}");
            rethrow; // Optionally rethrow to handle it elsewhere
          }
        }).toList();
      } else {
        debugPrint("No documents found in Firestore matching the query.");
      }
    } catch (e) {
      debugPrint("Error fetching locations from Firestore: $e");
    }
    return []; // Return an empty list if no matches found
  }


/*  Future<List<Place>> fetchLocationsFromFirestore() async {
    try {
      // Fetch all documents from the cached_locations collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cached_locations')
          .get();

      debugPrint("Query executed. Number of documents fetched: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        // Return all documents mapped to Place objects
        return querySnapshot.docs.map((doc) {
          try {
            final data = doc.data();
            debugPrint("Processing document: ${doc.id}");
            debugPrint("Document data: $data");

            // Map document data to Place object
            return Place.fromJson(data);
          } catch (error) {
            debugPrint("Error mapping document ${doc.id} to Place: $error");
            debugPrint("Document data causing error: ${doc.data()}");
            rethrow; // Optionally rethrow to handle it elsewhere
          }
        }).toList();
      } else {
        debugPrint("No documents found in Firestore.");
      }
    } catch (e) {
      debugPrint("Error fetching locations from Firestore: $e");
    }
    return []; // Return an empty list if no documents are found
  }*/

/*
  Future<List<Place>> fetchLocationsWithFallback(List<String> userPreferences) async {
    final placeTypes = mapInterestsToPlaceTypes(userPreferences);
    debugPrint("Mapped user preferences to place types: $placeTypes");

    // Try to fetch locations from Firestore (checking secondaryPreferences)
    try {
      debugPrint("Attempting to fetch locations from Firestore (secondaryPreferences)...");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cached_locations')
          .where('secondaryPreferences', arrayContainsAny: placeTypes)
          .get();

      debugPrint("Query executed. Number of documents fetched: ${snapshot.docs.length}");

      if (snapshot.docs.isNotEmpty) {
        debugPrint("Locations found in Firestore (secondaryPreferences). Returning Firestore results.");
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data() as Map<String, dynamic>;
            debugPrint("Processing document: ${doc.id}");
            debugPrint("Document data: ${data.toString().substring(0, min(100000, data.toString().length))}");

            // Check if 'secondaryPreferences' is null or contains null values
            if (data['secondaryPreferences'] == null) {
              debugPrint("Warning: 'secondaryPreferences' is null in document ${doc.id}");
            } else {
              final secondaryPreferences = data['secondaryPreferences'];
              if (secondaryPreferences.contains(null)) {
                debugPrint("Warning: 'secondaryPreferences' contains null values in document ${doc.id}");
              }
            }

            // Check each field for unexpected nulls
            data.forEach((key, value) {
              if (value == null) {
                debugPrint("Warning: Field '$key' has a null value in document ${doc.id}");
              } else if (key == 'mainPreference' && value is! String) {
                debugPrint("Error: 'mainPreference' should be a String but got: ${value.runtimeType} in document ${doc.id}");
              }
              // Add more specific checks for fields if necessary
            });

            // Return Place object if no issues with data
            return Place.fromJson(data);
          } catch (error) {
            debugPrint("Error mapping document ${doc.id} to Place: $error");
            debugPrint("Document data causing error: ${doc.data()}");
            rethrow; // Optionally rethrow to handle it elsewhere
          }
        }).toList();
      } else {
        debugPrint("No documents found in Firestore matching the query.");
      }
    } catch (e) {
      debugPrint("Error fetching locations from Firestore (secondaryPreferences): $e");
    }

    // Fallback to Google API
    try {
      debugPrint("Fetching locations from Google API as fallback...");
      List<Place> googleApiResults = await fetchLocationsFromGoogleAPI(placeTypes);
      debugPrint("Successfully fetched locations from Google API.");
      return googleApiResults;
    } catch (e) {
      debugPrint("Error fetching locations from Google API: $e");
      return [];
    }
  }*/

 /* Future<List<Place>> fetchLocationsWithFallback(List<String> userPreferences) async {
    final subPlaceTypes = mapInterestsToPlaceTypes(userPreferences);
    debugPrint("Mapped user preferences to place types: $subPlaceTypes");

    // Try to fetch locations from Firestore (checking secondaryPreferences)
    try {
      debugPrint("Attempting to fetch locations from Firestore (secondaryPreferences)...");

      // Use CachedLocationDbService to get cached locations
      final cachedLocationDbService = CachedLocationDbService();
      final cachedLocations = await cachedLocationDbService.getCachedLocations();

      // Filter locations based on secondary preferences
      final filteredLocations = <Place>[];
      for (var cachedLocation in cachedLocations) {
        if (cachedLocation.secondaryPreferences != null &&
            cachedLocation.secondaryPreferences!.any((pref) => subPlaceTypes.contains(pref))) {
          debugPrint("Found matching locations in cached data.");
          if (cachedLocation.places != null) {
            for (var place in cachedLocation.places!) {
              filteredLocations.add(place);
            }
          }
        }
      }

      if (filteredLocations.isNotEmpty) {
        debugPrint("Locations found in Firestore (secondaryPreferences). Returning Firestore results.");
        return filteredLocations;
      } else {
        debugPrint("No matching locations found in cached Firestore data.");
      }
    } catch (e) {
      debugPrint("Error fetching locations from Firestore (secondaryPreferences): $e");
    }

    // Fallback to Google API if no results found in Firestore
    try {
      debugPrint("Fetching locations from Google API as fallback...");
      List<Place> googleApiResults = await fetchLocationsFromGoogleAPI(subPlaceTypes);
      debugPrint("Successfully fetched locations from Google API.");
      return googleApiResults;
    } catch (e) {
      debugPrint("Error fetching locations from Google API: $e");
      return [];
    }
  }

*/
  Future<List<TravelLocation>> fetchLocationsWithFallback(List<String> userPreferences) async {
    final subPlaceTypes = mapInterestsToPlaceTypes(userPreferences);
    final placeTypes = await getMainPreferences(userPreferences);
    debugPrint("Mapped user preferences to place types: $subPlaceTypes");

    // Initialize a list to hold TravelLocation objects
    final List<TravelLocation> resultLocations = [];

    try {
      debugPrint("Attempting to fetch locations from Firestore (secondaryPreferences)...");

      for (var placeType in placeTypes) {
        final activityTypeDoc = await FirebaseFirestore.instance
            .collection('travel_locations')
            .doc(placeType)
            .get();

        if (activityTypeDoc.exists) {
          // Parse the Firestore document into an ActivityType instance
          final activityType = ActivityType.fromFirestore(
            placeType,
            activityTypeDoc.data()!,
          );

          // Add the parsed TravelLocation objects to the result list
          resultLocations.addAll(activityType.locations); // Add all locations
        }
      }
    } catch (e) {
      debugPrint("Error fetching locations from Firestore: $e");
    }

    // If Firestore fetch fails, fallback to Google API call
    if (resultLocations.isEmpty) {
      debugPrint("No locations found in Firestore. Falling back to Google API call...");

      // Assuming you have a method to fetch locations from Google API
      //resultLocations.addAll(await fetchLocationsFromGoogleAPI(userPreferences));
    }

    return resultLocations; // Return the list of TravelLocation objects
  }




  Future<List<Place>> fetchLocationsFromGoogleAPI(List<String> userPreferences) async {
    final placeTypes = mapInterestsToPlaceTypes(userPreferences);
    final query = placeTypes.join('|');

    final url = Uri.parse(
        'https://placess.googleapis.com/v1/places:searchText?fields=places.id,places.formattedAddress,places.googleMapsUri,places.location,places.photos,places.displayName&key=$googlePlacesApiKey');

    final requestBody = {
      "textQuery": query,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['places'] != null) {
          final results = data['places'] as List<dynamic>;
          return results.map<Place>((json) => Place.fromJson(json)).toList();
        } else {
          throw Exception('No results found or invalid response format');
        }
      } else {
        throw Exception('Failed to fetch locations: ${response.body}');
      }
    } catch (e) {
      debugPrint("Error fetching locations from Google API: $e");
      return [];
    }
  }


  /*Future<List<PlacePhotos>> getPhotoUrls(List<Place> places) async {


    for (var place in places) {
      if (place.photos != null) {
        List<Future<String?>> photoFutures = [];

        for (var photoPath in place.photos!) {
          final photoUrl = Uri.parse(
            'https://places.googleapis.com/v1/$photoPath/media?key=$googlePlacesApiKey&maxHeightPx=800&maxWidthPx=800&skipHttpRedirect=true',
          );
          print('Fetching photo for path: $photoPath');
          photoFutures.add(_fetchPhotoUrl(photoUrl, photoPath));
        }

        List<String?> fetchedPhotoUrls = await Future.wait(photoFutures);
        List<String> validPhotoUrls = fetchedPhotoUrls.where((url) => url != null).cast<String>().toList();

        // Add the results to the placePhotosList
        placePhotosList.add(PlacePhotos(placeId: place.id, photoUrls: validPhotoUrls));
      }
    }

    return placePhotosList;
  }

  Future<String?> _fetchPhotoUrl(Uri photoUrl, String photoPath) async {
    try {
      final response = await http.get(photoUrl);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['url'] != null) {
          return jsonResponse['url'];
        }
      } else {
        print('Failed to load photo URL for $photoPath: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching photo URL for $photoPath: $e');
    }
    return null;
  }*/

  Future<void> getRecommendedLocations() async {
    try {
      places = await fetchLocationsWithFallback(selectedInterests);
      //places = await fetchLocationsFromFirestore();
      List<String> placeTypes = await mapInterestsToPlaceTypes(selectedInterests);
      if (!_isDisposed) {
        setState(() {}); // Update the UI with the fetched places
      }
    } catch (e) {
      print("Error fetching recommended locations: $e");
    }
  }

/*
  Future<void> getimage() async {
    try {
      // Call the updated getPhotoUrls method
      List<PlacePhotos> placePhotosList = await getPhotoUrls(places!);

      // Update the state only if the widget is not disposed
      if (!_isDisposed) {
        setState(() {
          placePhotoUrls = placePhotosList; // Store the result in placePhotoUrls
        });
        print("Fetched place photo URLs: $placePhotoUrls");
      }
    } catch (e) {
      print("Error fetching recommended locations: $e");
    }
  }*/

  bool _validateDates() {
    final now = DateTime.now();

    if (_startDate == null || _endDate == null) {
      _showErrorSnackbar('Please select both start and end dates.');
      return false;
    }

    if (_startDate!.isBefore(now)) {
      _showErrorSnackbar('Start date cannot be in the past.');
      return false;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showErrorSnackbar('End date cannot be before the start date.');
      return false;
    }

    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Journey'),
        elevation: 0,
        backgroundColor: const Color(0xFF00B4DB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plan Your Adventure',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF08649A),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDateField(
                        'Start Date',
                        _startDate,
                            (newDate) => setState(() {
                          _startDate = newDate;
                        }),
                        _startDateController,
                      ),
                      const SizedBox(height: 16.0),
                      _buildDateField(
                        'End Date',
                        _endDate,
                            (newDate) => setState(() {
                          _endDate = newDate;
                        }),
                        _endDateController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Interests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: interests.map((interest) {
                  return FilterChip(
                    label: Text(interest),
                    selected: selectedInterests.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF00B4DB),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validateDates() && selectedInterests.isNotEmpty) {
                      await getRecommendedLocations();

                      if (places != null && places!.isNotEmpty) {
                        final journey = Journey(
                          startDate: _startDate!,
                          endDate: _endDate!,
                          selectedInterests: selectedInterests,
                          email: userEmail!,
                        );
                        JourneyDbService().addJourneyIfNotExist(journey);

                        if (!_isDisposed) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectPersonalizeRoute(

                                place: places,
                              ),
                            ),
                          );
                        }
                      } else {
                        _showErrorSnackbar('No places found. Try different interests.');
                      }
                    } else if (selectedInterests.isEmpty) {
                      _showErrorSnackbar('Please select at least one interest.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    backgroundColor: const Color(0xFF00B4DB),
                  ),
                  child: const Text(
                    'Create Your Own Journey',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime?) onSelectDate, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          onSelectDate(selectedDate);
          controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        }
      },
    );
  }
  }
