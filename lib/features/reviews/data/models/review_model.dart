// lib/features/reviews/data/models/review_model.dart

class ReviewModel {
  final String id;
  final String bookingId;
  final String userId;
  final String userName;
  final String providerId;
  final String providerName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? photos;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.providerId,
    required this.providerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.photos,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      photos: json['photos'] != null
          ? List<String>.from(json['photos'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'userName': userName,
      'providerId': providerId,
      'providerName': providerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'photos': photos,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? bookingId,
    String? userId,
    String? userName,
    String? providerId,
    String? providerName,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? photos,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      photos: photos ?? this.photos,
    );
  }

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}