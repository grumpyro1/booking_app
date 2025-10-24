// lib/features/booking/presentation/screens/booking_detail_screen.dart

import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/booking_model.dart';
import '../../../reviews/data/providers/review_provider.dart';
import '../../../reviews/presentation/screens/write_review_screen.dart';
import 'reschedule_booking_screen.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider.notifier).getBookingById(bookingId);
    final hasReview = ref.watch(reviewProvider.notifier).hasReview(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        actions: [
          if (booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.accepted)
            PopupMenuButton(
              itemBuilder: (context) => [
                if (booking.status == BookingStatus.accepted)
                  const PopupMenuItem(
                    value: 'reschedule',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20),
                        SizedBox(width: 12),
                        Text('Reschedule'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'cancel',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Cancel Booking', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'reschedule') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RescheduleBookingScreen(booking: booking),
                    ),
                  );
                } else if (value == 'cancel') {
                  _showCancelDialog(context, ref, booking.id);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _getStatusColor(booking.status).withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(booking.status),
                    color: _getStatusColor(booking.status),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.statusText,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(booking.status),
                              ),
                        ),
                        Text(
                          _getStatusMessage(booking.status),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: _getStatusColor(booking.status),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Booking Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking ID
                  _InfoSection(
                    icon: Icons.receipt_long,
                    title: 'Booking ID',
                    child: SelectableText(
                      booking.id,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Divider(height: 32),

                  // Provider Info
                  _InfoSection(
                    icon: Icons.store,
                    title: 'Service Provider',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.providerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (booking.status == BookingStatus.completed && !hasReview)
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WriteReviewScreen(booking: booking),
                                ),
                              );
                              if (result == true && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thank you for your review!'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.rate_review),
                            label: const Text('Write Review'),
                          )
                        else if (hasReview)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Review Submitted',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Divider(height: 32),

                  // Services
                  _InfoSection(
                    icon: Icons.list_alt,
                    title: 'Services',
                    child: Column(
                      children: booking.services.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.quantity}x',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.service.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.service.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₱${item.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Divider(height: 32),

                  // Schedule
                  _InfoSection(
                    icon: Icons.calendar_today,
                    title: 'Schedule',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              booking.formattedDate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              booking.scheduledTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 32),

                  // Location
                  _InfoSection(
                    icon: Icons.location_on,
                    title: 'Service Address',
                    child: Text(
                      booking.serviceAddress,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  if (booking.notes != null) ...[
                    const Divider(height: 32),
                    _InfoSection(
                      icon: Icons.note,
                      title: 'Notes',
                      child: Text(
                        booking.notes!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],

                  const Divider(height: 32),

                  // Price Breakdown
                  _InfoSection(
                    icon: Icons.payments,
                    title: 'Payment Summary',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('₱${booking.subtotal.toStringAsFixed(0)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service Fee'),
                            Text('₱${booking.serviceFee.toStringAsFixed(0)}'),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₱${booking.total.toStringAsFixed(0)}',
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
                        const SizedBox(height: 16),
                        // Payment Method Display
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getPaymentIcon(booking.paymentMethod),
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    booking.paymentMethodText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (booking.cancellationReason != null) ...[
                    const Divider(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.red),
                              const SizedBox(width: 8),
                              const Text(
                                'Cancellation Reason',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            booking.cancellationReason!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Booking Timeline
                  Text(
                    'Booking Timeline',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _TimelineItem(
                    icon: Icons.check_circle,
                    title: 'Booking Created',
                    time: booking.createdAt,
                    isCompleted: true,
                  ),
                  if (booking.status != BookingStatus.cancelled) ...[
                    _TimelineItem(
                      icon: Icons.schedule,
                      title: 'Pending Confirmation',
                      isCompleted: booking.status != BookingStatus.pending,
                    ),
                    _TimelineItem(
                      icon: Icons.check,
                      title: 'Confirmed',
                      isCompleted: booking.status == BookingStatus.accepted ||
                          booking.status == BookingStatus.inProgress ||
                          booking.status == BookingStatus.completed,
                    ),
                    _TimelineItem(
                      icon: Icons.handyman,
                      title: 'In Progress',
                      isCompleted: booking.status == BookingStatus.inProgress ||
                          booking.status == BookingStatus.completed,
                    ),
                    _TimelineItem(
                      icon: Icons.check_circle,
                      title: 'Completed',
                      isCompleted: booking.status == BookingStatus.completed,
                      isLast: true,
                    ),
                  ] else
                    _TimelineItem(
                      icon: Icons.cancel,
                      title: 'Cancelled',
                      isCompleted: true,
                      isLast: true,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.accepted:
        return AppColors.info;
      case BookingStatus.inProgress:
        return AppColors.primary;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.accepted:
        return Icons.check_circle;
      case BookingStatus.inProgress:
        return Icons.handyman;
      case BookingStatus.completed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusMessage(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Waiting for provider confirmation';
      case BookingStatus.accepted:
        return 'Provider confirmed your booking';
      case BookingStatus.inProgress:
        return 'Service is being performed';
      case BookingStatus.completed:
        return 'Service completed successfully';
      case BookingStatus.cancelled:
        return 'This booking has been cancelled';
    }
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cod':
      case 'cash on delivery':
        return Icons.payments;
      case 'gcash':
        return Icons.account_balance_wallet;
      case 'card':
      case 'credit card':
      case 'debit card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String bookingId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this booking?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'Tell us why you\'re cancelling',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = reasonController.text.trim().isEmpty
                  ? 'No reason provided'
                  : reasonController.text.trim();

              await ref.read(bookingProvider.notifier).cancelBooking(
                    bookingId,
                    reason,
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled successfully'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime? time;
  final bool isCompleted;
  final bool isLast;
  final Color? color;

  const _TimelineItem({
    required this.icon,
    required this.title,
    this.time,
    required this.isCompleted,
    this.isLast = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? (isCompleted ? AppColors.primary : AppColors.textSecondary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: itemColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: itemColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? itemColor.withOpacity(0.5)
                    : AppColors.textSecondary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: itemColor,
                ),
              ),
              if (time != null)
                Text(
                  '${time!.day}/${time!.month}/${time!.year} ${time!.hour}:${time!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}