import '../../../home/presentation/screens/orig_home_screen.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final List<ServiceItem> services; // Changed from single service to list
  final DateTime bookingDate;
  final String timeSlot;
  final double totalAmount;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.services,
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
  
  // Get total service count
  int get serviceCount {
    return services.fold(0, (sum, item) => sum + item.quantity);
  }
  
  // Get main service name (for display)
  String get mainServiceName {
    if (services.isEmpty) return 'No services';
    if (services.length == 1) return services.first.service.name;
    return '${services.first.service.name} +${services.length - 1} more';
  }
  
  // Get provider name
  String get providerName {
    if (services.isEmpty) return '';
    return services.first.service.provider;
  }
}

// Service item within a booking
class ServiceItem {
  final Service service;
  final int quantity;

  ServiceItem({
    required this.service,
    required this.quantity,
  });

  double get totalPrice => service.price * quantity;
}