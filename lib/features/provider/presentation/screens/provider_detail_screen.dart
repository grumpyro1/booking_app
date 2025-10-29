// lib/features/providers/presentation/screens/provider_detail_screen.dart

import 'package:booking_app/features/home/data/models/service_provider_model.dart';
import 'package:booking_app/shared/widgets/category_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/mock_providers_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/data/providers/cart_provider.dart';
import '../../../favorites/data/providers/favorites_provider.dart';
import '../../../reviews/data/providers/review_provider.dart';
import '../../../reviews/presentation/screens/provider_reviews_screen.dart';

class ProviderDetailScreen extends ConsumerWidget {
  final ServiceProviderModel provider;

  const ProviderDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerServices = mockServices
        .where((service) => service.providerId == provider.id)
        .toList();

    final cart = ref.watch(cartProvider)[provider.id];
    final cartItemCount = cart?.totalItems ?? 0;
    final isFavorite = ref.watch(favoritesProvider).contains(provider.id);
    final reviews = ref.watch(reviewProvider.notifier).getReviewsByProvider(provider.id);
    final averageRating = ref.watch(reviewProvider.notifier).getAverageRating(provider.id);
    final reviewsCount = reviews.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(provider.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? 'Removed from favorites': 'Added to favorites'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          if (cartItemCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   '/single-cart',
                    //   arguments: provider.id,
                    // );
                    // context.push('/single-cart',extra: provider.id);
                    context.push('/single-cart/${provider.id}');
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: AppColors.primary.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CategoryIconHelper.getCategoryIcon(provider.category),
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${provider.rating} (${provider.reviewCount} reviews)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              provider.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              provider.phone,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Reviews Section - MAKE IT IN WIDGET
                  if (reviewsCount > 0) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProviderReviewsScreen(
                                providerId: provider.id,
                                providerName: provider.name,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < averageRating.round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$reviewsCount review${reviewsCount > 1 ? 's' : ''}',
                                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Tap to see all reviews',
                                    style: TextStyle(fontSize: 12,color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Services Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Available Services',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Services List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: providerServices.length,
                    itemBuilder: (context, index) {
                      final service = providerServices[index];
                      final isInCart = ref.read(cartProvider.notifier).isServiceInCart(
                            provider.id,
                            service.id,
                          );
                      final quantity = ref.read(cartProvider.notifier).getServiceQuantity(
                            provider.id,
                            service.id,
                          );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          service.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: AppColors.textSecondary),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              service.duration,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₱${service.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (!isInCart)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).addService(service);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${service.name} added to cart'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                                )
                              else
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('In Cart'),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (quantity > 1) {
                                              ref.read(cartProvider.notifier).updateQuantity(provider.id,service.id,quantity - 1);
                                            } else {
                                              ref.read(cartProvider.notifier).removeService(provider.id,service.id);
                                            }
                                          },
                                          icon: const Icon(Icons.remove_circle_outline),
                                          color: AppColors.primary,
                                        ),
                                        Text(
                                          '$quantity',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            ref.read(cartProvider.notifier).updateQuantity(provider.id,service.id,quantity + 1);
                                          },
                                          icon: const Icon(Icons.add_circle_outline),
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Cart Button
          if (cartItemCount > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   '/single-cart',
                      //   arguments: provider.id,
                      // );
                      // context.push('/single-cart',extra: provider.id);
                      context.push('/single-cart/${provider.id}');

                    },
                    child: Text('View Cart ($cartItemCount items)'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}