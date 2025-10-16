import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/bookings_repository.dart';

// Repository provider
final bookingsRepositoryProvider = Provider((ref) {
  final repo = BookingsRepository();
  repo.initializeMockData(); // Initialize with mock data
  return repo;
});

// All bookings provider
final allBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getAllBookings();
});

// Upcoming bookings provider
final upcomingBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getUpcomingBookings();
});

// Past bookings provider
final pastBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getPastBookings();
});

// Selected tab provider (0 = All, 1 = Upcoming, 2 = Past)
final bookingsTabProvider = StateProvider<int>((ref) => 1); // Default to Upcoming