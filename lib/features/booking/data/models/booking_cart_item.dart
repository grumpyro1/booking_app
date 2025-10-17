import '../../../home/presentation/screens/orig_home_screen.dart';

class BookingCartItem {
  final Service service;
  final int quantity;

  BookingCartItem({
    required this.service,
    this.quantity = 1,
  });

  BookingCartItem copyWith({
    Service? service,
    int? quantity,
  }) {
    return BookingCartItem(
      service: service ?? this.service,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => service.price * quantity;
}