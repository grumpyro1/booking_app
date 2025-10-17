import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/booking_cart_item.dart';
import '../../../home/presentation/screens/orig_home_screen.dart';

class BookingCartNotifier extends StateNotifier<List<BookingCartItem>> {
  BookingCartNotifier() : super([]);

  // Add service to cart
  void addService(Service service) {
    // Check if service already in cart
    final existingIndex = state.indexWhere((item) => item.service.id == service.id);
    
    if (existingIndex >= 0) {
      // Increase quantity
      final updatedItems = [...state];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = updatedItems;
    } else {
      // Add new item
      state = [...state, BookingCartItem(service: service)];
    }
  }

  // Remove service from cart
  void removeService(String serviceId) {
    state = state.where((item) => item.service.id != serviceId).toList();
  }

  // Update quantity
  void updateQuantity(String serviceId, int quantity) {
    if (quantity <= 0) {
      removeService(serviceId);
      return;
    }

    final updatedItems = state.map((item) {
      if (item.service.id == serviceId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    
    state = updatedItems;
  }

  // Clear cart
  void clearCart() {
    state = [];
  }

  // Get total price
  double get totalPrice {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Get total items count
  int get itemCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Provider
final bookingCartProvider = StateNotifierProvider<BookingCartNotifier, List<BookingCartItem>>(
  (ref) => BookingCartNotifier(),
);

// Computed providers
final cartTotalPriceProvider = Provider<double>((ref) {
  final cart = ref.watch(bookingCartProvider);
  return cart.fold(0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(bookingCartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});