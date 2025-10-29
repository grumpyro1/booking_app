// lib/features/booking/presentation/screens/booking_success_screen.dart

import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
import 'package:booking_app/features/home/presentation/screens/new_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class BookingSuccessScreen extends ConsumerWidget {
  final String bookingId;

  const BookingSuccessScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider.notifier).getBookingById(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Success Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 80,
                        color: AppColors.success,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Booking Confirmed!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Your booking has been successfully created',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Booking Details Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Booking ID',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              SelectableText(
                                booking.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 24),

                          // Provider
                          _buildDetailRow(
                            context,
                            icon: Icons.store,
                            label: 'Service Provider',
                            value: booking.providerName,
                          ),

                          const SizedBox(height: 16),

                          // Date & Time
                          _buildDetailRow(
                            context,
                            icon: Icons.calendar_today,
                            label: 'Scheduled',
                            value:
                                '${booking.formattedDate} at ${booking.scheduledTime}',
                          ),

                          const SizedBox(height: 16),

                          // Address
                          _buildDetailRow(
                            context,
                            icon: Icons.location_on,
                            label: 'Location',
                            value: booking.deliveryAddress['fullAddress'] ?? 'No address provided',
                          ),

                          const SizedBox(height: 16),

                          // Services Count
                          _buildDetailRow(
                            context,
                            icon: Icons.list_alt,
                            label: 'Services',
                            value: '${booking.services.length} service${booking.services.length > 1 ? 's' : ''}',
                          ),

                          const SizedBox(height: 16),

                          // Total
                          _buildDetailRow(
                            context,
                            icon: Icons.payments,
                            label: 'Total Amount',
                            value: '₱${booking.total.toStringAsFixed(0)}',
                            valueColor: AppColors.primary,
                            valueWeight: FontWeight.bold,
                          ),

                          const Divider(height: 24),

                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 18,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Status: ${booking.statusText}',
                                    style: TextStyle(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What\'s Next?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.info,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'The service provider will review and confirm your booking. You\'ll receive a notification once they accept.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.info),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamedAndRemoveUntil(
                          //   context,
                          //   '/home',
                          //   (route) => false,
                          // );
                          context.go('/home/bookings');

                          // Switch to bookings tab
                          // ref.read(selectedIndexProvider.notifier).state = 1;
                        },
                        child: const Text('View My Bookings'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigator.pushNamedAndRemoveUntil(
                          //   context,
                          //   '/home',
                          //   (route) => false,
                          // );
                          context.go('/home');
                        },
                        child: const Text('Back to Home'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: valueWeight ?? FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}