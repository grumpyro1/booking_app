import 'package:booking_app/core/theme/app_colors.dart';
import 'package:booking_app/features/payment/presentation/screens/checkout_screen.dart';
import 'package:flutter/material.dart';

class PaymentOptionWidget extends StatelessWidget {
  
  final IconData icon;
  final String title;
  final String subtitle;
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?>? onChanged;
  final bool isEnabled;

  const PaymentOptionWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isEnabled ? AppColors.border : AppColors.border.withOpacity(0.3)),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isEnabled ? Colors.white : Colors.grey[50],
      ),
      child: RadioListTile<PaymentMethod>(
        value: value,
        groupValue: groupValue,
        onChanged: isEnabled ? onChanged : null,
        title: Row(
          children: [
            Icon(
              icon,
              color: isEnabled ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isEnabled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Soon',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ),
          ],
        ),
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}