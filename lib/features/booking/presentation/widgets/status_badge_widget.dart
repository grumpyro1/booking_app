import 'package:booking_app/core/theme/app_colors.dart';
import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:flutter/material.dart';

class StatusBadgeWidget extends StatelessWidget {
  final BookingStatus status;

  const StatusBadgeWidget({required this.status});

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