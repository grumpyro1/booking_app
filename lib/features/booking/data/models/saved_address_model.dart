// lib/features/booking/data/models/saved_address_model.dart

enum AddressType {
  home,
  work,
  other,
}

class SavedAddressModel {
  final String id;
  final String userId;
  final AddressType type;
  final String label; // "Home", "Work", or custom label
  final double latitude;
  final double longitude;
  final String fullAddress;
  final String street;
  final String city;
  final String postalCode;
  final String houseNumber;
  final String? notes;
  final bool isDefault;
  final DateTime createdAt;

  SavedAddressModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.houseNumber,
    this.notes,
    this.isDefault = false,
    required this.createdAt,
  });

  String get icon {
    switch (type) {
      case AddressType.home:
        return '🏠';
      case AddressType.work:
        return '💼';
      case AddressType.other:
        return '📍';
    }
  }

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) {
    return SavedAddressModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: AddressType.values.firstWhere(
        (e) => e.toString() == 'AddressType.${json['type']}',
      ),
      label: json['label'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fullAddress: json['fullAddress'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      houseNumber: json['houseNumber'] as String,
      notes: json['notes'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'label': label,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'houseNumber': houseNumber,
      'notes': notes,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  SavedAddressModel copyWith({
    String? id,
    String? userId,
    AddressType? type,
    String? label,
    double? latitude,
    double? longitude,
    String? fullAddress,
    String? street,
    String? city,
    String? postalCode,
    String? houseNumber,
    String? notes,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return SavedAddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      label: label ?? this.label,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fullAddress: fullAddress ?? this.fullAddress,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      houseNumber: houseNumber ?? this.houseNumber,
      notes: notes ?? this.notes,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to delivery address format
  Map<String, dynamic> toDeliveryAddress() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'houseNumber': houseNumber,
      'notes': notes,
    };
  }
}