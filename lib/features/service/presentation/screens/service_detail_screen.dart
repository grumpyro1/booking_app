import 'package:booking_app/features/booking/data/provider/booking_cart_provider.dart';
import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
import 'package:booking_app/shared/widgets/floating_booking_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ServiceDetailScreen extends ConsumerWidget  {
  final Service service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <-- add WidgetRef ref
    return Stack(
      children: [
        Scaffold(
          // appBar: AppBar(
          //   title: const Text('Service Details'),
          //   actions: [
          //     FavoriteButton(
          //       serviceId: service.id,
          //       serviceName: service.name,
          //     ),
          //   ],
          // ),
          body: CustomScrollView(
            slivers: [
        
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image,size: 100,color: Colors.grey[400]),
                  ),
                ),
              ),
        
              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
        
                          // Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6,),
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              service.category,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary,fontWeight: FontWeight.bold),
                            ),
                          ),
        
                          const SizedBox(height: 12),
        
                          // Service Name
                          Text(
                            service.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
        
                          const SizedBox(height: 8),
        
                          // Provider
                          Row(
                            children: [
                              const Icon(Icons.store,size: 20,color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                service.provider,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
        
                          const SizedBox(height: 12),
        
                          // Rating
                          Row(
                            children: [
                              const Icon(Icons.star,color: Colors.amber,size: 24),
        
                              const SizedBox(width: 8),
        
                              Text(
                                service.rating.toString(),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(128 reviews)',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
        
                          const SizedBox(height: 24),
        
                          // Price
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1),borderRadius: BorderRadius.circular(12)),
                            
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                                    const SizedBox(height: 4),
                                    Text('Rp ${service.price.toStringAsFixed(0)}',style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary,fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text('per session',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
        
                          const SizedBox(height: 24),
        
                          // Description Section
                          Text(
                            'About this service',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                          ),
        
                          const SizedBox(height: 12),
                          Text(
                            'Experience the authentic ${service.name} in the heart of Bali. Our professional team ensures you get the best experience with traditional techniques passed down through generations.\n\nPerfect for relaxation and rejuvenation, this service is designed to help you unwind and find your inner peace.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary,height: 1.6),
                          ),
        
                          const SizedBox(height: 24),
        
                          // What's Included
                          Text(
                            'What\'s included',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 12),
                          _buildIncludedItem(context, Icons.check_circle, 'Professional instructor'),
                          _buildIncludedItem(context, Icons.check_circle, 'All necessary equipment'),
                          _buildIncludedItem(context, Icons.check_circle, 'Refreshments included'),
                          _buildIncludedItem(context, Icons.check_circle, 'Certificate of completion'),
        
                          const SizedBox(height: 24),
        
                          // Location
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                          ),
        
                          const SizedBox(height: 12),
        
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.border),borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1),borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.location_on,color: AppColors.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(service.provider,style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Ubud, Bali, Indonesia',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.map),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open map - Coming soon')));
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100), // Space for bottom button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        
          // Bottom Book Now Button
          // Bottom buttons
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
          ),
          child: SafeArea(
        child: Row(
          children: [
            // Add to Booking Button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(bookingCartProvider.notifier).addService(service);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${service.name} added to booking'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'View Cart',
                        textColor: Colors.white,
                        onPressed: () {
                          context.push('/booking-cart');
                        },
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: const Text(
                  'Add to Booking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Book Now Button (Single service)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/booking', extra: service);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
          ),
        ),
        ),
        FloatingBookingSummary()
      ],
    );
  }

  Widget _buildIncludedItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon,color: AppColors.success,size: 20),
          const SizedBox(width: 12),
          Text(text,style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}