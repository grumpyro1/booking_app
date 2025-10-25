// lib/features/booking/presentation/screens/checkout_screen.dart

import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
import 'package:booking_app/features/payment/presentation/widgets/payment_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/provider/auth_provider.dart';
import '../../../cart/data/providers/cart_provider.dart';
import '../../../cart/data/models/cart_model.dart';

enum PaymentMethod {
  cod,
  gcash,
  card,
}

class CheckoutScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingDetails;

  const CheckoutScreen({super.key, required this.bookingDetails});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.cod;
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // For now, only COD works
      if (_selectedPayment != PaymentMethod.cod) {
        throw Exception('Only Cash on Delivery is available at the moment');
      }

      // Create the booking after payment is confirmed
      final user = ref.read(authProvider).user;
      if (user == null) {
        throw Exception('User not found');
      }

      final booking = await ref.read(bookingProvider.notifier).createBooking(
            userId: user.id,
            providerId: widget.bookingDetails['providerId'],
            providerName: widget.bookingDetails['providerName'],
            services: widget.bookingDetails['services'] as List<CartItemModel>,
            subtotal: widget.bookingDetails['subtotal'],
            serviceFee: widget.bookingDetails['serviceFee'],
            // serviceAddress: widget.bookingDetails['serviceAddress'],
            deliveryAddress: widget.bookingDetails['deliveryAddress'] as Map<String, dynamic>, // Changed
            scheduledDate: widget.bookingDetails['scheduledDate'],
            scheduledTime: widget.bookingDetails['scheduledTime'],
            notes: widget.bookingDetails['notes'],
          );

      // Clear the cart after successful booking
      ref.read(cartProvider.notifier).clearCart(
            widget.bookingDetails['providerId'],
          );

      if (mounted) {
        // Navigate to success screen
        context.pushReplacement('/booking-success', extra: booking.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.bookingDetails['subtotal'] as double;
    final serviceFee = widget.bookingDetails['serviceFee'] as double;
    final total = subtotal + serviceFee;
    final services = widget.bookingDetails['services'] as List<CartItemModel>;
    final providerName = widget.bookingDetails['providerName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary Header
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Booking Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.store, color: AppColors.primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                providerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${services.length} service${services.length > 1 ? 's' : ''}',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            Text(
                              '₱${subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service Fee',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            Text(
                              '₱${serviceFee.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₱${total.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Payment Method Section
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // COD Option
                  PaymentOptionWidget(
                    icon: Icons.payments,
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when service is completed',
                    value: PaymentMethod.cod,
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        _selectedPayment = value!;
                      });
                    },
                    isEnabled: true,
                  ),

                  const SizedBox(height: 12),

                  // GCash Option (Disabled)
                  PaymentOptionWidget(
                    icon: Icons.account_balance_wallet,
                    title: 'GCash',
                    subtitle: 'Coming soon',
                    value: PaymentMethod.gcash,
                    groupValue: _selectedPayment,
                    onChanged: null,
                    isEnabled: false,
                  ),

                  const SizedBox(height: 12),

                  // Card Option (Disabled)
                  PaymentOptionWidget(
                    icon: Icons.credit_card,
                    title: 'Credit/Debit Card',
                    subtitle: 'Coming soon',
                    value: PaymentMethod.card,
                    groupValue: _selectedPayment,
                    onChanged: null,
                    isEnabled: false,
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
                                'Payment Information',
                                style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.info),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'For Cash on Delivery: Please prepare the exact amount. You can pay the service provider when the service is completed.',
                                style: TextStyle(fontSize: 13,color: AppColors.info),
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

          // Bottom Button
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Payment',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            '₱${total.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _processPayment,
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  )
                                : const Text('Confirm Payment'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}