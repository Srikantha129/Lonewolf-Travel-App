import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lonewolf/screens/route_optimitation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/JourneyEntry.dart';

class JourneyPage extends StatefulWidget {
  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  final _auth = FirebaseAuth.instance;
  List<JourneyEntry> userJourneys = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkLoginStatus();
    _fetchUserJourneys();
  }

  /// Checks the login status and retrieves the user's email.
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _fetchUserJourneys() async {
    if (userEmail != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('personaljourneys')
          .get();

      List<JourneyEntry> matchedJourneys = [];

      // Iterate through each document and check the first location's email in the entries array
      for (var doc in querySnapshot.docs) {
        List<dynamic> entries = doc['entries'] as List<dynamic>;

        // Check if the first entry's email matches the user's email
        if (entries.isNotEmpty && entries[0]['email'] == userEmail) {
          // If it matches, add all entries in this document to matchedJourneys
          matchedJourneys.addAll(
            entries.map((entry) => JourneyEntry.fromFirestore(entry as Map<String, dynamic>)),
          );
        }
      }

      setState(() {
        userJourneys = matchedJourneys;
      });
    }
  }


  void _onJourneySelected(JourneyEntry journey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionPage(journey: journey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Journeys')),
      body: ListView.builder(
        itemCount: userJourneys.length,
        itemBuilder: (context, index) {
          final journey = userJourneys[index];
          return ListTile(
            title: Text(journey.displayName),
            subtitle: Text(journey.description),
            onTap: () => _onJourneySelected(journey),
          );
        },
      ),
    );
  }
}
