// lib/features/booking/data/models/booking_model.dart

import 'package:booking_app/features/home/data/models/service_model.dart';
import '../../../cart/data/models/cart_model.dart';


// enum BookingListType { active, completed, cancelled }

enum BookingStatus {
  pending,    // Waiting for provider to accept
  accepted,   // Provider accepted, scheduled
  inProgress, // Service is being performed
  completed,  // Service completed
  cancelled,  // Booking cancelled
}

class BookingModel {
  final String id;
  final String userId;
  final String providerId;
  final String providerName;
  final List<CartItemModel> services;
  final double subtotal;
  final double serviceFee;
  final double total;
  // final String serviceAddress;
  final Map<String, dynamic> deliveryAddress; // Changed from String to Map

  final DateTime scheduledDate;
  final String scheduledTime;
  final BookingStatus status;
  final DateTime createdAt;
  final String? notes;
  final String? cancellationReason;
  final String paymentMethod; // Added payment method

  BookingModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.providerName,
    required this.services,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.deliveryAddress,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.createdAt,
    this.notes,
    this.cancellationReason,
    this.paymentMethod = 'cod', // Default to COD
  });


  // Helper getter to get full address string
  String get fullAddress => deliveryAddress['fullAddress'] ?? '';
  
  // Helper getter to get house number
  String get houseNumber => deliveryAddress['houseNumber'] ?? '';
  
  // Helper getter to get delivery notes
  String get deliveryNotes => deliveryAddress['notes'] ?? '';

  // Helper getter to get coordinates
  double? get latitude => deliveryAddress['latitude'] as double?;
  double? get longitude => deliveryAddress['longitude'] as double?;


  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      services: (json['services'] as List)
          .map((item) => CartItemModel(
                service: ServiceModel.fromJson(item['service']),
                quantity: item['quantity'] as int,
              ))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      // serviceAddress: json['serviceAddress'] as String,
      deliveryAddress: json['deliveryAddress'] as Map<String, dynamic>? ?? {}, // Changed
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      scheduledTime: json['scheduledTime'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      paymentMethod: json['paymentMethod'] as String? ?? 'cod',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'providerId': providerId,
      'providerName': providerName,
      'services': services
          .map((item) => {
                'service': item.service.toJson(),
                'quantity': item.quantity,
              })
          .toList(),
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'total': total,
      'serviceAddress': deliveryAddress,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'cancellationReason': cancellationReason,
      'paymentMethod': paymentMethod,
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? providerName,
    List<CartItemModel>? services,
    double? subtotal,
    double? serviceFee,
    double? total,
    Map<String, dynamic>? deliveryAddress, 
    DateTime? scheduledDate,
    String? scheduledTime,
    BookingStatus? status,
    DateTime? createdAt,
    String? notes,
    String? cancellationReason,
    String? paymentMethod,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      services: services ?? this.services,
      subtotal: subtotal ?? this.subtotal,
      serviceFee: serviceFee ?? this.serviceFee,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending Confirmation';
      case BookingStatus.accepted:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod.toLowerCase()) {
      case 'cod':
        return 'Cash on Delivery';
      case 'gcash':
        return 'GCash';
      case 'card':
        return 'Credit/Debit Card';
      default:
        return paymentMethod;
    }
  }

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[scheduledDate.month - 1]} ${scheduledDate.day}, ${scheduledDate.year}';
  }
}