/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lonewolf/models/popular_experiences.dart';
import 'package:lonewolf/services/popular_experiences_db_service.dart';

// FutureProvider to fetch popular experiences
final popularExperiencesProvider = FutureProvider<List<PopularExperience>>((ref) async {
  return await fetchPopularExperiences();
});
*/

// popular_experiences_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lonewolf/services/popular_experiences_db_service.dart';
import 'package:lonewolf/models/popular_experiences.dart';

// Create an instance of the PopularExperienceService
final popularExperienceServiceProvider = Provider<PopularExperienceService>((ref) {
  return PopularExperienceService();
});

// StreamProvider to fetch popular experiences in real-time
final popularExperiencesProvider = StreamProvider<List<PopularExperience>>((ref) {
  final popularExperienceService = ref.watch(popularExperienceServiceProvider); // Get the service instance
  return popularExperienceService.streamPopularExperiences(); // Call the stream method
});


