import 'package:booking_app/features/booking/presentation/screens/confirmation_screen.dart';
import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
import 'package:booking_app/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  final Service service;
  final DateTime selectedDate;
  final String selectedTime;
  final String notes;

  const CheckoutScreen({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.notes,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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
  double get _subtotal => widget.service.price;
  double get _serviceFee => widget.service.price * 0.05; // 5% service fee
  double get _total => _subtotal + _serviceFee;

  Future<void> _processBooking() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Navigate to confirmation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          service: widget.service,
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
          total: _total,
          bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}',
        ),
      ),
    );
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
                  // Service Info
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
                              widget.service.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.service.provider,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Date & Time
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE, MMMM dd, yyyy').format(widget.selectedDate),
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
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDisabled ? Colors.grey : null,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method['description'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    'Subtotal',
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

          const SizedBox(height: 100), // Space for bottom button
        ],
      ),
      // Bottom Payment Button
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
              // Total Amount Display
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
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(label: 'Confirm & Pay', onPressed: _isProcessing ? null : () => _processBooking()),
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