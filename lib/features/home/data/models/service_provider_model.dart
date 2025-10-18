// lib/features/providers/data/models/service_provider_model.dart

class ServiceProviderModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String address;
  final String phone;
  final bool isAvailable;
  final List<String> serviceTypes;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.phone,
    required this.isAvailable,
    required this.serviceTypes,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      address: json['address'] as String,
      phone: json['phone'] as String,
      isAvailable: json['isAvailable'] as bool,
      serviceTypes: List<String>.from(json['serviceTypes'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'phone': phone,
      'isAvailable': isAvailable,
      'serviceTypes': serviceTypes,
    };
  }

  ServiceProviderModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? address,
    String? phone,
    bool? isAvailable,
    List<String>? serviceTypes,
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isAvailable: isAvailable ?? this.isAvailable,
      serviceTypes: serviceTypes ?? this.serviceTypes,
    );
  }
}