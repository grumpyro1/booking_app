// lib/features/booking/data/providers/saved_address_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saved_address_model.dart';

class SavedAddressNotifier extends Notifier<List<SavedAddressModel>> {
  @override
  List<SavedAddressModel> build() {
    return [];
  }

  // Save a new address
  Future<void> saveAddress({
    required String userId,
    required AddressType type,
    required String label,
    required double latitude,
    required double longitude,
    required String fullAddress,
    required String street,
    required String city,
    required String postalCode,
    required String houseNumber,
    String? notes,
    bool setAsDefault = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // If setting as default, unset others
    if (setAsDefault) {
      state = state.map((addr) => addr.copyWith(isDefault: false)).toList();
    }

    final newAddress = SavedAddressModel(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      label: label,
      latitude: latitude,
      longitude: longitude,
      fullAddress: fullAddress,
      street: street,
      city: city,
      postalCode: postalCode,
      houseNumber: houseNumber,
      notes: notes,
      isDefault: setAsDefault || state.isEmpty, // First address is default
      createdAt: DateTime.now(),
    );

    state = [...state, newAddress];
  }

  // Update an existing address
  Future<void> updateAddress(String addressId, SavedAddressModel updatedAddress) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.map((addr) {
      if (addr.id == addressId) {
        return updatedAddress;
      }
      return addr;
    }).toList();
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.where((addr) => addr.id != addressId).toList();

    // If deleted address was default, set first one as default
    if (state.isNotEmpty && !state.any((addr) => addr.isDefault)) {
      state = [
        state.first.copyWith(isDefault: true),
        ...state.skip(1),
      ];
    }
  }

  // Set an address as default
  Future<void> setDefaultAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.map((addr) {
      return addr.copyWith(isDefault: addr.id == addressId);
    }).toList();
  }

  // Get all saved addresses
  List<SavedAddressModel> getSavedAddresses() {
    return state;
  }

  // Get default address
  SavedAddressModel? getDefaultAddress() {
    try {
      return state.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  // Get addresses by type
  List<SavedAddressModel> getAddressesByType(AddressType type) {
    return state.where((addr) => addr.type == type).toList();
  }

  // Check if address already exists
  bool addressExists(double latitude, double longitude) {
    return state.any((addr) =>
        (addr.latitude - latitude).abs() < 0.0001 &&
        (addr.longitude - longitude).abs() < 0.0001);
  }
}

final savedAddressProvider = NotifierProvider<SavedAddressNotifier, List<SavedAddressModel>>(() {
  return SavedAddressNotifier();
});