import 'package:cloud_firestore/cloud_firestore.dart';

import 'Journey.dart';

class Journey {
  final String email;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> selectedInterests;
  final Map<String, String> journeys;

  Journey({
    required this.email,
    required this.startDate,
    required this.endDate,
    required this.selectedInterests,
    this.journeys = const {},
  });

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      email: json['email'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      selectedInterests: List<String>.from(json['selectedInterests']),
      journeys: Map<String, String>.from(json['journeys'] ?? const {}),
    );
  }

  factory Journey.fromMap(Map<String, dynamic> data) {
    return Journey(
      email: data['email'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      selectedInterests: List<String>.from(data['selectedInterests']),
      journeys: Map<String, String>.from(data['journeys']),
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'selectedInterests': selectedInterests,
    'journeys': journeys,
  };

}
