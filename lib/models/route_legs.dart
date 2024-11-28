import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteLeg {
  final Polyline polyline;
  final int durationInSeconds;
  final int distanceInMeters;

  RouteLeg({
    required this.polyline,
    required this.durationInSeconds,
    required this.distanceInMeters,
  });
}