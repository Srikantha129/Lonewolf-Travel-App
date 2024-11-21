import 'dart:convert';
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
import '../models/Preferences.dart';

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
  List<Place>? places;
  List<PlacePhotos> placePhotosList = [];
  List<PlacePhotos> placePhotoUrls = [];
  bool _isDisposed = false;
  String? userEmail;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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

  List<String> mapInterestsToPlaceTypes(List<String> userInterests) {
    final placeTypes = <String>[];
    for (var interest in userInterests) {
      if (interestToPlaceTypes.containsKey(interest.replaceAll('#', ''))) {
        placeTypes.addAll(interestToPlaceTypes[interest.replaceAll('#', '')]!);
      }
    }
    return placeTypes;
  }

  Future<List<Place>> fetchLocations(List<String> userPreferences) async {
    final placeTypes = mapInterestsToPlaceTypes(userPreferences);
    final query = placeTypes.join('|');

    final url = Uri.parse(
        'https://places.googleapis.com/v1/places:searchText?fields=places.id,places.formattedAddress,places.googleMapsUri,places.location,places.photos,places.displayName&key=$googlePlacesApiKey'
    );

    final requestBody = {
      "textQuery": query,
    };

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
      places = await fetchLocations(selectedInterests);
      if (!_isDisposed) {
        setState(() {});  // Ensure widget is still mounted
      }
    } catch (e) {
      print("Error fetching recommended locations: $e");
    }
    //await getimage();
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

                                place: places!,
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
