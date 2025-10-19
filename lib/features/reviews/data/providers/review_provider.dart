// lib/features/reviews/data/providers/review_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';

class ReviewNotifier extends Notifier<List<ReviewModel>> {
  @override
  List<ReviewModel> build() {
    return []; // Empty list initially
  }

  // Create a new review
  Future<ReviewModel> createReview({
    required String bookingId,
    required String userId,
    required String userName,
    required String providerId,
    required String providerName,
    required double rating,
    required String comment,
    List<String>? photos,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final review = ReviewModel(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      userId: userId,
      userName: userName,
      providerId: providerId,
      providerName: providerName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
      photos: photos,
    );

    state = [...state, review];
    return review;
  }

  // Get reviews for a provider
  List<ReviewModel> getReviewsByProvider(String providerId) {
    return state.where((review) => review.providerId == providerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get reviews by a user
  List<ReviewModel> getReviewsByUser(String userId) {
    return state.where((review) => review.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get review for a booking
  ReviewModel? getReviewByBooking(String bookingId) {
    try {
      return state.firstWhere((review) => review.bookingId == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Check if booking has review
  bool hasReview(String bookingId) {
    return state.any((review) => review.bookingId == bookingId);
  }

  // Get average rating for provider
  double getAverageRating(String providerId) {
    final reviews = getReviewsByProvider(providerId);
    if (reviews.isEmpty) return 0.0;
    
    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  // Get rating distribution for provider
  Map<int, int> getRatingDistribution(String providerId) {
    final reviews = getReviewsByProvider(providerId);
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    
    for (var review in reviews) {
      final ratingKey = review.rating.round();
      distribution[ratingKey] = (distribution[ratingKey] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Get total reviews count for provider
  int getReviewsCount(String providerId) {
    return getReviewsByProvider(providerId).length;
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.where((review) => review.id != reviewId).toList();
  }

  // Update review
  Future<void> updateReview({
    required String reviewId,
    double? rating,
    String? comment,
    List<String>? photos,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.map((review) {
      if (review.id == reviewId) {
        return review.copyWith(
          rating: rating ?? review.rating,
          comment: comment ?? review.comment,
          photos: photos ?? review.photos,
        );
      }
      return review;
    }).toList();
  }
}

final reviewProvider = NotifierProvider<ReviewNotifier, List<ReviewModel>>(() {
  return ReviewNotifier();
});