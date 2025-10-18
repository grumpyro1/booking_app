import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/booking_model.dart';

class BookingDetailScreen extends ConsumerWidget {
  final BookingModel booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(booking.status).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(booking.status),
                    color: _getStatusColor(booking.status),
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.statusText,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(booking.status),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusDescription(booking.status),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Booking ID
            _buildSectionTitle(context, 'Booking Information'),
            const SizedBox(height: 12),
            _buildInfoCard(context, [
              _buildInfoRow(context, 'Booking ID', booking.id),
              _buildInfoRow(
                context,
                'Booking Date',
                DateFormat('MMM dd, yyyy • hh:mm a').format(booking.createdAt),
              ),
            ]),

            const SizedBox(height: 24),

            // Services List
            _buildSectionTitle(context, 'Services Booked (${booking.services.length})'),
            const SizedBox(height: 12),
            ...booking.services.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.service.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.service.provider,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.service.duration,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
children: [
const Icon(
Icons.star,
size: 16,
color: Colors.amber,
),
const SizedBox(width: 4),
Text(
item.service.rating.toString(),
style: Theme.of(context).textTheme.bodySmall,
),
const SizedBox(width: 16),
if (item.quantity > 1)
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
'Qty: ${item.quantity}',
style: Theme.of(context)
.textTheme
.bodySmall
?.copyWith(
color: AppColors.primary,
fontWeight: FontWeight.bold,
),
),
),
],
),
Text(
'Rp ${item.totalPrice.toStringAsFixed(0)}',
style: Theme.of(context)
.textTheme
.titleMedium
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
)),
        const SizedBox(height: 24),

        // Appointment Details
        _buildSectionTitle(context, 'Appointment Details'),
        const SizedBox(height: 12),
        _buildInfoCard(context, [
          _buildInfoRow(
            context,
            'Date',
            DateFormat('EEEE, MMMM dd, yyyy').format(booking.bookingDate),
          ),
          _buildInfoRow(context, 'Time', booking.timeSlot),
          _buildInfoRow(context, 'Location', 'Ubud, Bali'),
        ]),

        if (booking.notes != null && booking.notes!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Additional Notes'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              booking.notes!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Payment Details
        _buildSectionTitle(context, 'Payment Details'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Individual service prices
                ...booking.services.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.service.name} ${item.quantity > 1 ? '(x${item.quantity})' : ''}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            'Rp ${item.totalPrice.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Paid',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Rp ${booking.totalAmount.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 100),
      ],
    ),
  ),
  bottomNavigationBar: booking.canCancel
      ? Container(
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
            child: OutlinedButton(
              onPressed: () {
                _showCancelDialog(context, ref);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Cancel Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      : null,
);
}
Widget _buildSectionTitle(BuildContext context, String title) {
return Text(
title,
style: Theme.of(context).textTheme.titleLarge?.copyWith(
fontWeight: FontWeight.bold,
),
);
}
Widget _buildInfoCard(BuildContext context, List<Widget> children) {
return Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: children,
),
),
);
}
Widget _buildInfoRow(BuildContext context, String label, String value) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
label,
style: Theme.of(context).textTheme.bodyMedium?.copyWith(
color: AppColors.textSecondary,
),
),
const SizedBox(width: 16),
Expanded(
child: Text(
value,
style: Theme.of(context).textTheme.bodyMedium?.copyWith(
fontWeight: FontWeight.w600,
),
textAlign: TextAlign.right,
),
),
],
),
);
}
Color _getStatusColor(BookingStatus status) {
switch (status) {
case BookingStatus.pending:
return AppColors.warning;
case BookingStatus.confirmed:
return AppColors.success;
case BookingStatus.completed:
return AppColors.info;
case BookingStatus.cancelled:
return AppColors.error;
}
}
IconData _getStatusIcon(BookingStatus status) {
switch (status) {
case BookingStatus.pending:
return Icons.schedule;
case BookingStatus.confirmed:
return Icons.check_circle;
case BookingStatus.completed:
return Icons.task_alt;
case BookingStatus.cancelled:
return Icons.cancel;
}
}
String _getStatusDescription(BookingStatus status) {
switch (status) {
case BookingStatus.pending:
return 'Waiting for confirmation';
case BookingStatus.confirmed:
return 'Your booking is confirmed';
case BookingStatus.completed:
return 'This service has been completed';
case BookingStatus.cancelled:
return 'This booking was cancelled';
}
}
void _showCancelDialog(BuildContext context, WidgetRef ref) {
showDialog(
context: context,
builder: (dialogContext) => AlertDialog(
title: const Text('Cancel Booking'),
content: const Text(
'Are you sure you want to cancel this booking? This action cannot be undone.',
),
actions: [
TextButton(
onPressed: () => Navigator.pop(dialogContext),
child: const Text('No, Keep It'),
),
TextButton(
onPressed: () async {
Navigator.pop(dialogContext);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cancelling booking...')),
          );

          final repository = ref.read(bookingsRepositoryProvider);
          final success = await repository.cancelBooking(booking.id);

          if (success) {
            ref.invalidate(allBookingsProvider);
            ref.invalidate(upcomingBookingsProvider);
            ref.invalidate(pastBookingsProvider);

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          }
        },
        child: const Text(
          'Yes, Cancel',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
  ),
);
}
}