import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lonewolf/models/popular_places.dart';
import 'package:lonewolf/services/popular_places_db_service.dart'; // Adjust the path as needed

// Provider for PopularPlaceDbService
final popularPlaceDbServiceProvider = Provider<PopularPlaceDbService>((ref) {
  return PopularPlaceDbService();
});

// FutureProvider to fetch popular places
final popularPlacesProvider = FutureProvider<List<PopularPlace>>((ref) async {
  final dbService = ref.read(popularPlaceDbServiceProvider);
  return await dbService.getPopularPlaces();
});
