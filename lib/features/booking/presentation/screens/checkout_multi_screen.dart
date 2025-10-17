import 'package:booking_app/features/booking/data/provider/booking_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/booking_cart_item.dart';

class CheckoutMultiScreen extends ConsumerStatefulWidget {
  final List<BookingCartItem> cartItems;
  final DateTime selectedDate;
  final String selectedTime;
  final String notes;

  const CheckoutMultiScreen({
    super.key,
    required this.cartItems,
    required this.selectedDate,
    required this.selectedTime,
    required this.notes,
  });

  @override
  ConsumerState<CheckoutMultiScreen> createState() => _CheckoutMultiScreenState();
}

class _CheckoutMultiScreenState extends ConsumerState<CheckoutMultiScreen> {
  String _selectedPaymentMethod = 'cash';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'name': 'Cash',
      'icon': Icons.money,
      'description': 'Pay with cash on arrival',
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'description': 'Pay with card (Coming soon)',
      'disabled': true,
    },
    {
      'id': 'ewallet',
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet,
      'description': 'Pay with GoPay, OVO, Dana (Coming soon)',
      'disabled': true,
    },
  ];

  // Calculate fees and total
  double get _subtotal {
    return widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get _serviceFee => _subtotal * 0.05; // 5% service fee
  double get _total => _subtotal + _serviceFee;

  Future<void> _processBooking() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Clear cart after successful booking
    ref.read(bookingCartProvider.notifier).clearCart();

    // Navigate to confirmation
    context.pushReplacement('/confirmation-multi', extra: {
      'cartItems': widget.cartItems,
      'selectedDate': widget.selectedDate,
      'selectedTime': widget.selectedTime,
      'total': _total,
      'bookingId': 'BK${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Booking Summary Section
          Text(
            'Booking Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Services List
                  ...widget.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 25,
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
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    '${item.service.provider} • ${item.service.duration}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  if (item.quantity > 1)
                                    Text(
                                      'Qty: ${item.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${item.totalPrice.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Date & Time
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE, MMMM dd, yyyy')
                        .format(widget.selectedDate),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.access_time,
                    'Time',
                    widget.selectedTime,
                  ),
                  if (widget.notes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.note,
                      'Notes',
                      widget.notes,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Payment Method Section
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ..._paymentMethods.map((method) {
            final isSelected = _selectedPaymentMethod == method['id'];
            final isDisabled = method['disabled'] ?? false;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          _selectedPaymentMethod = method['id'];
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDisabled
                              ? Colors.grey[200]
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          method['icon'],
                          color: isDisabled ? Colors.grey : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDisabled ? Colors.grey : null,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method['description'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDisabled
                                        ? Colors.grey
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: method['id'],
                        groupValue: _selectedPaymentMethod,
                        onChanged: isDisabled
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // Price Breakdown Section
          Text(
            'Price Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPriceRow(
                    'Subtotal (${widget.cartItems.length} services)',
                    _subtotal,
                    isTotal: false,
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    'Service Fee (5%)',
                    _serviceFee,
                    isTotal: false,
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    'Total',
                    _total,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Rp ${_total.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isProcessing ? null : _processBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm & Pay',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {required bool isTotal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : null,
              ),
        ),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : null,
                color: isTotal ? AppColors.primary : null,
              ),
        ),
      ],
    );
  }
}