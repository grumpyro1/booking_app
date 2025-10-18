// lib/features/cart/data/providers/cart_provider.dart

import 'package:booking_app/features/home/data/models/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';

class CartNotifier extends Notifier<Map<String, CartModel>> {
  @override
  Map<String, CartModel> build() {
    return {}; // Empty map: providerId -> CartModel
  }

  // Add service to cart
  void addService(ServiceModel service) {
    final providerId = service.providerId;
    final currentCarts = {...state};

    if (currentCarts.containsKey(providerId)) {
      // Provider cart already exists, add to it
      final cart = currentCarts[providerId]!;
      final existingItemIndex = cart.items.indexWhere(
        (item) => item.service.id == service.id,
      );

      if (existingItemIndex >= 0) {
        // Service already in cart, increase quantity
        final updatedItems = [...cart.items];
        updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
          quantity: updatedItems[existingItemIndex].quantity + 1,
        );
        currentCarts[providerId] = cart.copyWith(items: updatedItems);
      } else {
        // New service, add to cart
        final updatedItems = [...cart.items, CartItemModel(service: service)];
        currentCarts[providerId] = cart.copyWith(items: updatedItems);
      }
    } else {
      // Create new cart for this provider
      currentCarts[providerId] = CartModel(
        providerId: providerId,
        providerName: service.providerName,
        items: [CartItemModel(service: service)],
      );
    }

    state = currentCarts;
  }

  // Remove service from cart
  void removeService(String providerId, String serviceId) {
    final currentCarts = {...state};
    
    if (currentCarts.containsKey(providerId)) {
      final cart = currentCarts[providerId]!;
      final updatedItems = cart.items.where((item) => item.service.id != serviceId).toList();
      
      if (updatedItems.isEmpty) {
        // Cart is empty, remove it
        currentCarts.remove(providerId);
      } else {
        currentCarts[providerId] = cart.copyWith(items: updatedItems);
      }
      
      state = currentCarts;
    }
  }

  // Update quantity
  void updateQuantity(String providerId, String serviceId, int newQuantity) {
    if (newQuantity <= 0) {
      removeService(providerId, serviceId);
      return;
    }

    final currentCarts = {...state};
    
    if (currentCarts.containsKey(providerId)) {
      final cart = currentCarts[providerId]!;
      final updatedItems = cart.items.map((item) {
        if (item.service.id == serviceId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();
      
      currentCarts[providerId] = cart.copyWith(items: updatedItems);
      state = currentCarts;
    }
  }

  // Clear specific provider cart
  void clearCart(String providerId) {
    final currentCarts = {...state};
    currentCarts.remove(providerId);
    state = currentCarts;
  }

  // Clear all carts
  void clearAllCarts() {
    state = {};
  }

  // Get cart for specific provider
  CartModel? getCart(String providerId) {
    return state[providerId];
  }

  // Get total number of carts
  int get totalCarts => state.length;

  // Get total items across all carts
  int get totalItemsAllCarts {
    return state.values.fold(0, (sum, cart) => sum + cart.totalItems);
  }

  // Check if service is in cart
  bool isServiceInCart(String providerId, String serviceId) {
    final cart = state[providerId];
    if (cart == null) return false;
    return cart.items.any((item) => item.service.id == serviceId);
  }

  // Get service quantity in cart
  int getServiceQuantity(String providerId, String serviceId) {
    final cart = state[providerId];
    if (cart == null) return 0;
    
    final item = cart.items.firstWhere(
      (item) => item.service.id == serviceId,
      orElse: () => CartItemModel(service: ServiceModel(
        id: '',
        providerId: '',
        providerName: '',
        name: '',
        description: '',
        price: 0,
        duration: '',
        category: '',
        isAvailable: false,
      ), quantity: 0),
    );
    
    return item.quantity;
  }
}

final cartProvider = NotifierProvider<CartNotifier, Map<String, CartModel>>(() {
  return CartNotifier();
});