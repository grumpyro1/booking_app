import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';


enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final Service service;
  final DateTime bookingDate;
  final String timeSlot;
  final double totalAmount;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.service,
    required this.bookingDate,
    required this.timeSlot,
    required this.totalAmount,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get canCancel => status == BookingStatus.pending || status == BookingStatus.confirmed;
  bool get isUpcoming => status == BookingStatus.confirmed || status == BookingStatus.pending;
}