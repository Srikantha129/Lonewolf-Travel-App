/*import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/trip/trip_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/personalize_route.dart';
import '../../services/journey_db_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:lonewolf/services/personal_journey_db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TripHome extends StatefulWidget {
  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  String? userEmail;
  final personalJourneyService = PersonalJourneyService();
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();


  }
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      //displayName = prefs.getString('userName');
      print('received userEmail: $userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showDeleteDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 30),
              SizedBox(width: 10),
              Text(
                'Delete or Update Journey?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            'Do you want to delete the existing journey and create a new one, or just update the existing one?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Update Existing Journey Button (Top)
            TextButton(
              onPressed: () {
                // Close dialog and navigate to the next page to update the journey
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalizeRoute(), // Ensure this is the correct route
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: const Text(
                'Update Existing Journey',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Option to delete and create new journey
            TextButton(
              onPressed: () async {
                // Create an instance of PersonalJourneyService
                final personalJourneyService = PersonalJourneyService();

                // Perform delete action
                await personalJourneyService.deleteUserJourneyDocument(userEmail!);

                // Close dialog and navigate to the new journey creation page (or next page)
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalizeRoute(), // Ensure this is the correct route
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: const Text(
                'Delete and Create New',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Cancel Button (Bottom)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }



    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(fixPadding * 1.5),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.3, 0.6, 0.9],
              colors: [
                whiteColor.withOpacity(0.0),
                whiteColor.withOpacity(0.3),
                whiteColor.withOpacity(0.7),
                whiteColor.withOpacity(1.0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(fixPadding * 2.0),
                child: Text(
                  'Ready to customize your dream adventure?',
                  style: extraLargeBlackTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                child: Text(
                  'Plan your next unforgettable journey with Lonewolf!',
                  style: smallBoldGreyTextStyle,
                ),
              ),
              heightSpace,
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                *//*onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 1000),
                          child: TripMain()));
                },*//*
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  padding: EdgeInsets.all(fixPadding),
                  width: 140.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: primaryColor),
                  ),
                  child: Text(
                    'Add Experiences',
                    style: primaryColorButtonTextStyle,
                  ),
                ),
              ),
              heightSpace,
              heightSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                child: Text(
                  'OR',
                  style: smallBoldGreyTextStyle,
                ),
              ),
              heightSpace,
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () async {
                  bool journeyExists = await PersonalJourneyService().isExistsByEmail(userEmail!);
                  print(journeyExists);
                  print(userEmail);

                  if (journeyExists) {
                    // If journey exists, show the delete/update dialog
                    _showDeleteDialog();
                  } else {
                    // If no journey exists, navigate to the personalization route
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 1000),
                        child: PersonalizeRoute(*//*loggedUser: widget.loggedUser*//*),
                      ),
                    );
                  }
                },

                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  padding: EdgeInsets.all(fixPadding),
                  width: 140.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: primaryColor),
                  ),
                  child: Text(
                    'Explore trips',
                    style: primaryColorButtonTextStyle,
                  ),
                ),
              ),
              heightSpace,
              heightSpace,
            ],
          ),
        ),
      ),
    );

  }
}*/


/*
void _showDeleteDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Current Journey?'),
      content: const Text('This action is irreversible. Proceed?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await JourneyDbService()
                .deleteJourneyByEmail(widget.loggedUser.email!);
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonalizeRoute(loggedUser: widget.loggedUser),
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}*/

/*
void _showDeleteDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 30),
          SizedBox(width: 10),
          Text(
            'Delete or Update Journey?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      content: const Text(
        'Do you want to delete the existing journey and create a new one, or just update the existing one?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        // Update Existing Journey Button (Top)
        TextButton(
          onPressed: () {
            // Close dialog and navigate to the next page to update the journey
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalizeRoute(), // Ensure this is the correct route
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          child: const Text(
            'Update Existing Journey',
            style: TextStyle(fontSize: 16),
          ),
        ),
        // Option to delete and create new journey
        TextButton(
          onPressed: () async {
            // Create an instance of PersonalJourneyService
            final personalJourneyService = PersonalJourneyService();

            // Perform delete action
            await personalJourneyService.deleteUserJourneyDocument(userEmail!);

            // Close dialog and navigate to the new journey creation page (or next page)
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalizeRoute(), // Ensure this is the correct route
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          child: const Text(
            'Delete and Create New',
            style: TextStyle(fontSize: 16),
          ),
        ),
        // Cancel Button (Bottom)
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}*/


import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/trip/trip_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/personalize_route.dart';
import '../../services/journey_db_service.dart';
import '../../services/personal_journey_db_service.dart';
import '../experience/addexperience.dart';

class TripHome extends StatefulWidget {
  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  String? userEmail;
  final personalJourneyService = PersonalJourneyService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Function to show the dialog for journey options
    void _showJourneyOptionsDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                'Manage Your Journey',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            'Would you like to update your current journey or create a new one?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Update Journey Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalizeRoute(),
                  ),
                );
              },
              child: const Text(
                'Update Journey',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            // Delete and Create New Journey Button
            TextButton(
              onPressed: () async {
                await personalJourneyService.deleteUserJourneyDocument(userEmail!);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalizeRoute(),
                  ),
                );
              },
              child: const Text(
                'Create New Journey',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundImage.jpg'), // Use a travel-themed background
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan Your Dream Adventure!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Discover new destinations and personalize your journey.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              // Action Buttons
              Column(
                children: [
                  // Add Experiences Button
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 800),
                          child: const HostExperienceForm(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Add Experiences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Explore Trips Button
                  InkWell(
                    onTap: () async {
                      bool journeyExists = await PersonalJourneyService().isExistsByEmail(userEmail!);
                      if (journeyExists) {
                        _showJourneyOptionsDialog();
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 800),
                            child: PersonalizeRoute(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Explore Trips',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
