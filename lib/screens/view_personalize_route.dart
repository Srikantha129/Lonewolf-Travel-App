import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lonewolf/models/Location.dart';
import 'package:lonewolf/services/journey_db_service.dart';
import 'package:lonewolf/services/location_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPersonalizeRoute extends StatefulWidget {
  //final User loggedUser;

  const ViewPersonalizeRoute({
    super.key,
    //required this.loggedUser,
  });

  @override
  State<ViewPersonalizeRoute> createState() => _ViewPersonalizeRouteState();
}

class _ViewPersonalizeRouteState extends State<ViewPersonalizeRoute> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocationDbService _locationDbService = LocationDbService();
  List<Location> locations = [];
  Stream? _userJourney;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchData();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      // displayName = prefs.getString('userName');
      // print('received photoUrl: $photoURL');
    });
  }



  Future<void> _fetchData() async {
    _userJourney = JourneyDbService()
        .getJourneysByEmail(userEmail!);
    _userJourney!.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final journey = snapshot.docs.first.data();
        final journeys = journey.journeys as Map<String, String>;
        journeys.forEach((day, locationName) async {
          final locationStream =
              _locationDbService.getLocationByName(locationName);
          await for (final locationSnapshot in locationStream) {
            final locationData = locationSnapshot.docs.first.data() as Location;
            setState(() {
              locations.add(locationData);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/Logo1.png',
          height: 30.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ViewPersonalizeRoute(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _auth.signOut,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Your Personalized Routes List",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                          location.imageUrl.isEmpty
                              ? 'assets/images/bentota2.jpg'
                              : location.imageUrl,
                        ),
                        height: 200.0,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location.name,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    location.hashtags.join(', '),
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
