import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hotels.dart';
import '../services/hotels_db_service.dart';

// Service provider to manage the HotelService instance
final hotelServiceProvider = Provider<HotelService>((ref) {
  return HotelService();
});

// StreamProvider for hotels
final hotelStreamProvider = StreamProvider<List<Hotel>>((ref) {
  final hotelService = ref.read(hotelServiceProvider);
  return hotelService.getHotels();
});
