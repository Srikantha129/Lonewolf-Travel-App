import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OptimizedRouteMapPage extends StatelessWidget {
  final List<LatLng> routePoints;
  final List<Marker> markers;

  const OptimizedRouteMapPage({
    Key? key,
    required this.routePoints,
    required this.markers,
  }) : super(key: key);

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
