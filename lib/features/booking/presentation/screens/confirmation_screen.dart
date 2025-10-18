// import 'package:booking_app/features/booking/data/models/booking_model.dart';
// import 'package:booking_app/features/booking/data/provider/bookings_provider.dart';
// import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
// import 'package:booking_app/shared/widgets/button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/theme/app_colors.dart';

// class ConfirmationScreen extends ConsumerWidget {
//   final Service service;
//   final DateTime selectedDate;
//   final String selectedTime;
//   final double total;
//   final String bookingId;

//   const ConfirmationScreen({
//     super.key,
//     required this.service,
//     required this.selectedDate,
//     required this.selectedTime,
//     required this.total,
//     required this.bookingId,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     // Add booking to repository when screen loads
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final repository = ref.read(bookingsRepositoryProvider);
//     final booking = BookingModel(
//       id: bookingId,
//       service: service,
//       bookingDate: selectedDate,
//       timeSlot: selectedTime,
//       totalAmount: total,
//       status: BookingStatus.confirmed,
//       createdAt: DateTime.now(),
//     );
//     repository.addBooking(booking);
//   });
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 40),
                      
//                       // Success Icon
//                       Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           color: AppColors.success.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.check_circle,
//                           size: 80,
//                           color: AppColors.success,
//                         ),
//                       ),
                      
//                       const SizedBox(height: 24),
                      
//                       // Success Message
//                       Text(
//                         'Booking Confirmed!',
//                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.success,
//                             ),
//                         textAlign: TextAlign.center,
//                       ),
                      
//                       const SizedBox(height: 8),
                      
//                       Text(
//                         'Your booking has been successfully confirmed',
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: AppColors.textSecondary,
//                             ),
//                         textAlign: TextAlign.center,
//                       ),
                      
//                       const SizedBox(height: 32),
                      
//                       // Booking ID Card
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: AppColors.primary.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Booking ID',
//                               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     color: AppColors.textSecondary,
//                                   ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               bookingId,
//                               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.primary,
//                                     letterSpacing: 1.2,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
                      
//                       const SizedBox(height: 24),
                      
//                       // Booking Details Card
//                       Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Booking Details',
//                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                               const SizedBox(height: 20),
                              
//                               // Service
//                               _buildDetailRow(
//                                 context,
//                                 Icons.spa,
//                                 'Service',
//                                 service.name,
//                               ),
//                               const SizedBox(height: 16),
                              
//                               // Provider
//                               _buildDetailRow(
//                                 context,
//                                 Icons.store,
//                                 'Provider',
//                                 service.provider,
//                               ),
//                               const SizedBox(height: 16),
                              
//                               // Date
//                               _buildDetailRow(
//                                 context,
//                                 Icons.calendar_today,
//                                 'Date',
//                                 DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate),
//                               ),
//                               const SizedBox(height: 16),
                              
//                               // Time
//                               _buildDetailRow(
//                                 context,
//                                 Icons.access_time,
//                                 'Time',
//                                 selectedTime,
//                               ),
//                               const SizedBox(height: 16),
                              
//                               // Location
//                               _buildDetailRow(
//                                 context,
//                                 Icons.location_on,
//                                 'Location',
//                                 'Ubud, Bali',
//                               ),
                              
//                               const SizedBox(height: 20),
//                               const Divider(),
//                               const SizedBox(height: 20),
                              
//                               // Total Amount
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Total Paid',
//                                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                   ),
//                                   Text(
//                                     'Rp ${total.toStringAsFixed(0)}',
//                                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.primary,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 24),
                      
//                       // Info Box
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.info.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: AppColors.info.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.info_outline,
//                               color: AppColors.info,
//                               size: 24,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 'A confirmation email has been sent to your email address.',
//                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: AppColors.info,
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               // Bottom Buttons
//               const SizedBox(height: 20),
//               Column(
//                 children: [
//                   // View Bookings Button
//                   ButtonWidget(
//                     label: 'View My Bookings',
//                     onPressed: () {
//                       ref.read(selectedIndexProvider.notifier).state = 2;
//                       Navigator.of(context).popUntil((route) => route.isFirst);
//                     },
//                   ),
//                   const SizedBox(height: 12),

//                   // Back to Home Button
//                   ButtonWidget(
//                     label: 'Back to Home',
//                     onPressed: () {
//                       ref.read(selectedIndexProvider.notifier).state = 0;
//                       Navigator.of(context).popUntil((route) => route.isFirst);
//                     },
//                     isOutlined: true,
//                   ),
//                 ],
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String value,
//   ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppColors.textSecondary,
//                     ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

