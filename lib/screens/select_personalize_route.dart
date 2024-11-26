
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
import 'package:lonewolf/screens/personalize_route.dart';
import 'package:lonewolf/models/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//import '../models/Preferences.dart';
import 'package:lonewolf/models/JourneyEntry.dart';
import 'package:lonewolf/services/personal_journey_db_service.dart';
import 'package:lonewolf/models/new_places.dart';



class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this with a Lottie animation or any other animation
            Lottie.asset('assets/images/loading_anime.json', width: 200, height: 200),
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
  //final User loggedUser;
  final List<TravelLocation> place;

  //final List<PlacePhotos> placePhotoUrls ;



  const SelectPersonalizeRoute({
    super.key,
    // required this.loggedUser,
    required this.place,
    //required this.placePhotoUrls,


  });

  @override
  State<SelectPersonalizeRoute> createState() => _SelectPersonalizeRouteState();
}

class _SelectPersonalizeRouteState extends State<SelectPersonalizeRoute> {
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocationDbService _locationDbService = LocationDbService();
  List<JourneyLocation> locations = [];
  var  daycount = 0;
  //List<PlacePhotos> placePhotosList = [];
  //List<PlacePhotos> placePhotoUrls = [];
  //List<Preflocation> preflocations = [];
  String? _selectedDay = '01';
  Stream? _userJourney;
  List<DropdownMenuItem<String>> _dayItems = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchData();
    //getimage();
    _printPlaces();
    print('Places length: ${widget.place.length}'); // Debug log
  }

  // Function to print place details to the console
  void _printPlaces() {
    for (var place in widget.place) {
      print('Place name: ${place.displayName}');
      //print('Place id: ${place.id}');
      // You can print other properties as needed, like:
      // print('Place photo URL: ${place.photoUrl}');
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      // displayName = prefs.getString('userName');
      // print('received photoUrl: $photoURL');
    });
  }

/*
  Future<List<PlacePhotos>> getPhotoUrls(List<Place> places) async {


    for (var place in places) {
      if (place.photos != null) {
        List<Future<String?>> photoFutures = [];

        for (var photoPath in place.photos!) {
          final photoUrl = Uri.parse(
            'https://places.googleapis.com/v1/$photoPath/media?key=$googlePlacesApiKey&maxHeightPx=600&maxWidthPx=600&skipHttpRedirect=true',
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
      //print("response body: ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['photoUri'] != null) {
          return jsonResponse['photoUri'];
        }
      } else {
        print('Failed to load photo URL for $photoPath: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching photo URL for $photoPath: $e');
    }
    return null;
  }

  Future<void> getimage() async {
    try {
      // Call the updated getPhotoUrls method
      List<PlacePhotos> placePhotosList = await getPhotoUrls(widget.place);

      // Update the state only if the widget is not disposed

        setState(() {
          placePhotoUrls = placePhotosList; // Store the result in placePhotoUrls
          _isLoading = false;
        });
        print("Fetched place photo URLs: $placePhotoUrls");

    } catch (e) {
      print("Error fetching recommended locations: $e");
      setState(() {
        _isLoading = false; // Stop loading even if there is an error
      });
    }
  }

*/

  Future<void> _fetchData() async {
    locations = await _locationDbService.getLocations();
    _userJourney = JourneyDbService()
        .getJourneysByEmail(userEmail!);
    _userJourney!.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final journey = snapshot.docs.first.data();
        final dateDifference =
            journey.endDate.difference(journey.startDate).inDays;
        print('date difference $dateDifference');


        setState(() {
          _dayItems = _generateDayItems(dateDifference);
          daycount = dateDifference;
          _isLoading = false;
        });
      }
    });
  }

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
                  builder: (context) =>
                      ViewPersonalizeRoute(/*loggedUser: widget.loggedUser*/),
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
        body:
        Stack(
          children: [
            // ListView.builder wrapped in Expanded to take up all available space
            Positioned.fill( // Ensures ListView takes full space minus Positioned widget
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: widget.place.length,
                itemBuilder: (context, index) {
                  final place = widget.place[index];

                  // Use a default image if no photo URL exists for the place
                  final imageSource = (place.photoUrls.isNotEmpty)
                      ? place.photoUrls[0] // Safely access the first item if the list is not empty
                      : 'https://i.postimg.cc/hPZQ23q6/DALL-E-2024-10-24-21-56-40-A-friendly-illustration-showing-a-cute-cartoon-character-holding-a-wren.jpg'; // Default image

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
                        // Image with rounded corners
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
                                place.displayName.toString(),
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add to Trip'),
                                  onPressed: () {
                                    final selectedPlace = widget.place[index];

                                    JourneyEntry journeyEntry = JourneyEntry(
                                      day: _selectedDay ?? '01', // Default to '01' if _selectedDay is null
                                      email: userEmail ?? 'default@example.com', // Default email if null
                                      description: selectedPlace.description ?? 'Unknown Location', // Default name if null
                                      city: selectedPlace.city ?? '', // Default empty string if id is null
                                      openHours: selectedPlace.openHours ?? 'Unknown Address', // Default if null
                                      priceRange: selectedPlace.priceRange ?? '',
                                      userRating: selectedPlace.userRating ,// Default empty string if null
                                      latitude: selectedPlace.latitude ?? 0.0, // Default 0.0 if null
                                      longitude: selectedPlace.longitude ?? 0.0, // Default 0.0 if null
                                      photoUrls: selectedPlace.photoUrls ?? [], // Default empty list if null
                                      dayCount: daycount,
                                      locationName: selectedPlace.displayName,
                                    );


                                    PersonalJourneyService().addJourney(
                                        userEmail!, journeyEntry.toFirestore());

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${selectedPlace.displayName.toString()} added to your trip!'),
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

            // Positioned button at the bottom of the screen
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
                onPressed: () => launch('https://maps.app.goo.gl/PWhYGEJzFYHqXM5b6'),
              ),
            ),
          ],
        )

    );

  }

}
