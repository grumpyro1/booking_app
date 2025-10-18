// lib/features/booking/data/providers/booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../../../cart/data/models/cart_model.dart';

class BookingNotifier extends Notifier<List<BookingModel>> {
  @override
  List<BookingModel> build() {
    return []; // Empty list initially
  }

  // Create a new booking from cart
  Future<BookingModel> createBooking({
    required String userId,
    required String providerId,
    required String providerName,
    required List<CartItemModel> services,
    required double subtotal,
    required double serviceFee,
    required String serviceAddress,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? notes,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final booking = BookingModel(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      providerId: providerId,
      providerName: providerName,
      services: services,
      subtotal: subtotal,
      serviceFee: serviceFee,
      total: subtotal + serviceFee,
      serviceAddress: serviceAddress,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
      notes: notes,
    );

    state = [...state, booking];
    return booking;
  }

  // Get all bookings
  List<BookingModel> getAllBookings() {
    return state;
  }

  // Get active bookings (not completed or cancelled)
  List<BookingModel> getActiveBookings() {
    return state.where((booking) {
      return booking.status != BookingStatus.completed &&
          booking.status != BookingStatus.cancelled;
    }).toList();
  }

  // Get completed bookings
  List<BookingModel> getCompletedBookings() {
    return state.where((booking) {
      return booking.status == BookingStatus.completed;
    }).toList();
  }

  // Get cancelled bookings
  List<BookingModel> getCancelledBookings() {
    return state.where((booking) {
      return booking.status == BookingStatus.cancelled;
    }).toList();
  }

  // Get booking by ID
  BookingModel? getBookingById(String id) {
    try {
      return state.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(status: newStatus);
      }
      return booking;
    }).toList();
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(
          status: BookingStatus.cancelled,
          cancellationReason: reason,
        );
      }
      return booking;
    }).toList();
  }

  // Get bookings count by status
  int getBookingsCountByStatus(BookingStatus status) {
    return state.where((booking) => booking.status == status).length;
  }

  // Get total spent
  double getTotalSpent() {
    return state
        .where((booking) => booking.status == BookingStatus.completed)
        .fold(0, (sum, booking) => sum + booking.total);
  }
}

final bookingProvider = NotifierProvider<BookingNotifier, List<BookingModel>>(() {
  return BookingNotifier();
});