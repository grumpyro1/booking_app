// lib/features/providers/data/models/service_model.dart

class ServiceModel {
  final String id;
  final String providerId;
  final String providerName;
  final String name;
  final String description;
  final double price;
  final String duration;
  final String category;
  final bool isAvailable;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.isAvailable,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'providerName': providerName,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? name,
    String? description,
    double? price,
    String? duration,
    String? category,
    bool? isAvailable,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}