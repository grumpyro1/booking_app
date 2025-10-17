import 'package:booking_app/features/favorites/data/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class FavoriteButton extends ConsumerWidget {
  final String serviceId;
  final String serviceName;

  const FavoriteButton({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteNotifierProvider(serviceId));

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: () async {
        // Toggle favorite
        await ref.read(favoriteNotifierProvider(serviceId).notifier).toggle();
        
        // Invalidate the favorites list to refresh
        ref.invalidate(favoriteServicesProvider);

        // Show feedback
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? 'Removed from favorites'
                    : 'Added to favorites',
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              backgroundColor: isFavorite 
                  ? AppColors.textSecondary 
                  : AppColors.success,
            ),
          );
        }
      },
    );
  }
}