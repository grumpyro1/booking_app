// lib/features/cart/data/models/cart_model.dart

import 'package:booking_app/features/home/data/models/service_model.dart';

class CartItemModel {
  final ServiceModel service;
  final int quantity;

  CartItemModel({
    required this.service,
    this.quantity = 1,
  });

  double get totalPrice => service.price * quantity;

  CartItemModel copyWith({
    ServiceModel? service,
    int? quantity,
  }) {
    return CartItemModel(
      service: service ?? this.service,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String providerId;
  final String providerName;
  final List<CartItemModel> items;

  CartModel({
    required this.providerId,
    required this.providerName,
    required this.items,
  });

  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  CartModel copyWith({
    String? providerId,
    String? providerName,
    List<CartItemModel>? items,
  }) {
    return CartModel(
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      items: items ?? this.items,
    );
  }
}