import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/JourneyEntry.dart';

class LocationSelectionPage extends StatefulWidget {
  final JourneyEntry journey;

  LocationSelectionPage({required this.journey});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  String? startLocation;
  String? endLocation;
  String selectedMode = 'driving';

  final travelModes = ['driving', 'walking', 'bicycling', 'transit'];

  void _getOptimalRoute() {
    // Prepare coordinates and mode for the route API
    if (startLocation != null && endLocation != null) {
      final startCoords = widget.journey.photoUrls.firstWhere((loc) => loc == startLocation);
      final endCoords = widget.journey.photoUrls.firstWhere((loc) => loc == endLocation);

      // Call your route API here
      // Example API call (you'll need to implement this based on your route API)
      // RouteApi.getOptimalPath(startCoords, endCoords, selectedMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Start and End Locations')),
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            hint: Text('Select Start Location'),
            items: widget.journey.photoUrls.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
            onChanged: (value) => setState(() => startLocation = value),
          ),
          DropdownButtonFormField<String>(
            hint: Text('Select End Location'),
            items: widget.journey.photoUrls.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
            onChanged: (value) => setState(() => endLocation = value),
          ),
          DropdownButtonFormField<String>(
            hint: Text('Select Travel Mode'),
            items: travelModes.map((mode) => DropdownMenuItem(value: mode, child: Text(mode))).toList(),
            onChanged: (value) => setState(() => selectedMode = value ?? 'driving'),
          ),
          ElevatedButton(
            onPressed: _getOptimalRoute,
            child: Text('Get Optimal Route'),
          ),
        ],
      ),
    );
  }
}
