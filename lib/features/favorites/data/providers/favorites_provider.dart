// lib/features/favorites/data/providers/favorites_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {}; // Empty set of provider IDs
  }

  // Toggle favorite
  void toggleFavorite(String providerId) {
    final currentFavorites = {...state};
    
    if (currentFavorites.contains(providerId)) {
      currentFavorites.remove(providerId);
    } else {
      currentFavorites.add(providerId);
    }
    
    state = currentFavorites;
  }

  // Check if provider is favorite
  bool isFavorite(String providerId) {
    return state.contains(providerId);
  }

  // Get all favorites
  Set<String> getAllFavorites() {
    return state;
  }

  // Get favorites count
  int get favoritesCount => state.length;

  // Clear all favorites
  void clearAllFavorites() {
    state = {};
  }

  // Add favorite
  void addFavorite(String providerId) {
    if (!state.contains(providerId)) {
      state = {...state, providerId};
    }
  }

  // Remove favorite
  void removeFavorite(String providerId) {
    final currentFavorites = {...state};
    currentFavorites.remove(providerId);
    state = currentFavorites;
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(() {
  return FavoritesNotifier();
});