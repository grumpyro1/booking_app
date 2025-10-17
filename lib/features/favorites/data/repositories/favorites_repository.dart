import '../../../home/presentation/screens/orig_home_screen.dart';

class FavoritesRepository {
  // Mock favorites list - stores service IDs
  final Set<String> _favoriteServiceIds = {};

  // Check if service is favorite
  bool isFavorite(String serviceId) {
    return _favoriteServiceIds.contains(serviceId);
  }

  // Add to favorites
  Future<bool> addToFavorites(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate delay
    _favoriteServiceIds.add(serviceId);
    return true;
  }

  // Remove from favorites
  Future<bool> removeFromFavorites(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _favoriteServiceIds.remove(serviceId);
    return true;
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String serviceId) async {
    if (isFavorite(serviceId)) {
      await removeFromFavorites(serviceId);
      return false; // Now not favorite
    } else {
      await addToFavorites(serviceId);
      return true; // Now is favorite
    }
  }

  // Get all favorite services
  Future<List<Service>> getFavoriteServices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockServices
        .where((service) => _favoriteServiceIds.contains(service.id))
        .toList();
  }

  // Get favorites count
  int getFavoritesCount() {
    return _favoriteServiceIds.length;
  }
}