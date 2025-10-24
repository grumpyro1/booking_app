// lib/features/booking/presentation/screens/my_bookings_screen.dart

import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/booking_model.dart';
import 'booking_detail_screen.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BookingsList(type: BookingListType.active),
          _BookingsList(type: BookingListType.completed),
          _BookingsList(type: BookingListType.cancelled),
        ],
      ),
    );
  }
}

enum BookingListType { active, completed, cancelled }

class _BookingsList extends ConsumerWidget {
  final BookingListType type;

  const _BookingsList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBookings = ref.watch(bookingProvider);
    
    List<BookingModel> bookings;
    switch (type) {
      case BookingListType.active:
        bookings = allBookings.where((b) {
          return b.status != BookingStatus.completed && b.status != BookingStatus.cancelled;
        }).toList();
        break;
      case BookingListType.completed:
        bookings = allBookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
        break;
      case BookingListType.cancelled:
        bookings = allBookings
            .where((b) => b.status == BookingStatus.cancelled)
            .toList();
        break;
    }

    // Sort by date (newest first)
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyIcon(),
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubMessage(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(booking: booking);
        },
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (type) {
      case BookingListType.active:
        return Icons.event_available;
      case BookingListType.completed:
        return Icons.check_circle_outline;
      case BookingListType.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getEmptyMessage() {
    switch (type) {
      case BookingListType.active:
        return 'No Active Bookings';
      case BookingListType.completed:
        return 'No Completed Bookings';
      case BookingListType.cancelled:
        return 'No Cancelled Bookings';
    }
  }

  String _getEmptySubMessage() {
    switch (type) {
      case BookingListType.active:
        return 'You don\'t have any active bookings at the moment';
      case BookingListType.completed:
        return 'Your completed bookings will appear here';
      case BookingListType.cancelled:
        return 'You haven\'t cancelled any bookings';
    }
  }
}

class BookingCard extends ConsumerWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingDetailScreen(bookingId: booking.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.providerName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking ID: ${booking.id}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: booking.status),
                ],
              ),

              const Divider(height: 24),

              // Services
              Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${booking.services.length} service${booking.services.length > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Date & Time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${booking.formattedDate} at ${booking.scheduledTime}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.serviceAddress,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Total & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      Text(
                        '₱${booking.total.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),

                  // Action buttons based on status
                  if (booking.status == BookingStatus.pending ||
                      booking.status == BookingStatus.accepted)
                    OutlinedButton(
                      onPressed: () {
                        _showCancelDialog(context, ref, booking.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cancel'),
                    )
                  else if (booking.status == BookingStatus.completed)
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement book again
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Book Again - Coming soon')),
                        );
                      },
                      child: const Text('Book Again'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

              await ref.read(bookingProvider.notifier).cancelBooking(bookingId, reason);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking cancelled successfully')),
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

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case BookingStatus.pending:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        icon = Icons.schedule;
        break;
      case BookingStatus.accepted:
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        icon = Icons.check_circle;
        break;
      case BookingStatus.inProgress:
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        icon = Icons.handyman;
        break;
      case BookingStatus.completed:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case BookingStatus.cancelled:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            _getStatusText(status),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}