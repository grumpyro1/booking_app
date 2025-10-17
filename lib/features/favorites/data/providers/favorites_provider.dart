import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../../home/presentation/screens/orig_home_screen.dart';

// Repository provider
final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

// Check if a specific service is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, serviceId) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.isFavorite(serviceId);
});

// Get all favorite services
final favoriteServicesProvider = FutureProvider<List<Service>>((ref) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.getFavoriteServices();
});

// Favorites count
final favoritesCountProvider = Provider<int>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.getFavoritesCount();
});

// State notifier to handle favorite toggle with loading state
class FavoriteNotifier extends StateNotifier<bool> {
  final FavoritesRepository repository;
  final String serviceId;

  FavoriteNotifier(this.repository, this.serviceId) 
      : super(repository.isFavorite(serviceId));

  Future<void> toggle() async {
    final newState = await repository.toggleFavorite(serviceId);
    state = newState;
  }
}

final favoriteNotifierProvider = StateNotifierProvider.family<FavoriteNotifier, bool, String>(
  (ref, serviceId) {
    final repository = ref.watch(favoritesRepositoryProvider);
    return FavoriteNotifier(repository, serviceId);
  },
);