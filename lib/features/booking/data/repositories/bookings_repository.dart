import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';

import '../models/booking_model.dart';

class BookingsRepository {
  // Mock bookings list - this will store all bookings
  final List<BookingModel> _mockBookings = [];

  // Add a new booking
  void addBooking(BookingModel booking) {
    _mockBookings.add(booking);
  }

  // Get all bookings
  Future<List<BookingModel>> getAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(_mockBookings);
  }

  // Get upcoming bookings
  Future<List<BookingModel>> getUpcomingBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBookings
        .where((booking) => booking.isUpcoming)
        .toList()
      ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
  }

  // Get past bookings
  Future<List<BookingModel>> getPastBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBookings
        .where((booking) => 
          booking.status == BookingStatus.completed || 
          booking.status == BookingStatus.cancelled
        )
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _mockBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1 && _mockBookings[index].canCancel) {
      _mockBookings[index] = BookingModel(
        id: _mockBookings[index].id,
        service: _mockBookings[index].service,
        bookingDate: _mockBookings[index].bookingDate,
        timeSlot: _mockBookings[index].timeSlot,
        totalAmount: _mockBookings[index].totalAmount,
        status: BookingStatus.cancelled,
        notes: _mockBookings[index].notes,
        createdAt: _mockBookings[index].createdAt,
      );
      return true;
    }
    return false;
  }

  // Initialize with some mock data for testing
  void initializeMockData() {
    if (_mockBookings.isEmpty) {
      _mockBookings.addAll([
        BookingModel(
          id: 'BK1729000001',
          service: mockServices[0], // Balinese Massage
          bookingDate: DateTime.now().add(const Duration(days: 3)),
          timeSlot: '10:00 AM',
          totalAmount: 262500,
          status: BookingStatus.confirmed,
          notes: 'Please use aromatherapy oils',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        BookingModel(
          id: 'BK1729000002',
          service: mockServices[2], // Surfing Lesson
          bookingDate: DateTime.now().add(const Duration(days: 7)),
          timeSlot: '09:00 AM',
          totalAmount: 315000,
          status: BookingStatus.confirmed,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        BookingModel(
          id: 'BK1729000003',
          service: mockServices[4], // Yoga Session
          bookingDate: DateTime.now().subtract(const Duration(days: 5)),
          timeSlot: '07:00 AM',
          totalAmount: 157500,
          status: BookingStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ]);
    }
  }
}