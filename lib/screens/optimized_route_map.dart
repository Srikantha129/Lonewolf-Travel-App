/*

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OptimizedRouteMapPage extends StatelessWidget {
  final List<LatLng> routePoints;
  final List<Marker> markers;
  final String googleMapsUrl;

  const OptimizedRouteMapPage({
    super.key,
    required this.routePoints,
    required this.markers, required this.googleMapsUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Optimized Route"),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: routePoints.isNotEmpty ? routePoints.first : const LatLng(7.180647, 79.884098),
          zoom: 12,
        ),
        markers: Set<Marker>.of(markers),
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}


*/
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OptimizedRouteMapPage extends StatelessWidget {
  final List<LatLng> routePoints;
  final List<Marker> markers;
  final String googleMapsUrl;

  const OptimizedRouteMapPage({
    super.key,
    required this.routePoints,
    required this.markers,
    required this.googleMapsUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Optimized Route"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: routePoints.isNotEmpty ? routePoints.first : const LatLng(7.180647, 79.884098),
              zoom: 12,
            ),
            markers: Set<Marker>.of(markers),
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: routePoints,
                color: Colors.blue,
                width: 5,
              ),
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                if (await canLaunch(googleMapsUrl)) {
                  await launch(googleMapsUrl);
                } else {
                  throw 'Could not launch $googleMapsUrl';
                }
              },
              child: const Icon(Icons.directions),
            ),
          ),
        ],
      ),
    );
  }
}
