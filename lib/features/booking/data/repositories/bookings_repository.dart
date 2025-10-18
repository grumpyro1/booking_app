import '../models/booking_model.dart';
import '../../../home/presentation/screens/orig_home_screen.dart';

class BookingsRepository {
  // Mock bookings list - this will store all bookings
  final List<BookingModel> _mockBookings = [];

  // Add a new booking
  void addBooking(BookingModel booking) {
    _mockBookings.add(booking);
  }

  // Get all bookings
  Future<List<BookingModel>> getAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
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
        services: _mockBookings[index].services,
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
          services: [
            ServiceItem(
              service: Service(
                id: 'AC001',
                name: 'Aircon Cleaning',
                category: 'Home Services',
                serviceType: 'Aircon Services',
                price: 500,
                imageUrl: '',
                rating: 4.8,
                provider: 'Cool Tech Services',
                duration: '1-2 hours',
                description: 'Professional cleaning',
              ),
              quantity: 2,
            ),
            ServiceItem(
              service: Service(
                id: 'AC002',
                name: 'Aircon Installation',
                category: 'Home Services',
                serviceType: 'Aircon Services',
                price: 1200,
                imageUrl: '',
                rating: 4.9,
                provider: 'Cool Tech Services',
                duration: '2-3 hours',
                description: 'Expert installation',
              ),
              quantity: 1,
            ),
          ],
          bookingDate: DateTime.now().add(const Duration(days: 3)),
          timeSlot: '10:00 AM',
          totalAmount: 2200,
          status: BookingStatus.confirmed,
          notes: 'Please call before arrival',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        BookingModel(
          id: 'BK1729000002',
          services: [
            ServiceItem(
              service: Service(
                id: 'PL001',
                name: 'Leak Repair',
                category: 'Home Services',
                serviceType: 'Plumbing Services',
                price: 400,
                imageUrl: '',
                rating: 4.7,
                provider: 'Fix Flow Plumbing',
                duration: '1-2 hours',
                description: 'Fast repair',
              ),
              quantity: 1,
            ),
          ],
          bookingDate: DateTime.now().add(const Duration(days: 7)),
          timeSlot: '09:00 AM',
          totalAmount: 420,
          status: BookingStatus.confirmed,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);
    }
  }
}