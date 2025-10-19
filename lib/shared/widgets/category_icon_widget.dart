import 'package:flutter/material.dart';

class CategoryIconHelper {
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Aircon Services':
        return Icons.ac_unit;
      case 'Plumbing Services':
        return Icons.plumbing;
      case 'Electrical Services':
        return Icons.electrical_services;
      case 'Car Services':
        return Icons.directions_car;
      case 'Appliance Services':
        return Icons.kitchen;
      case 'Construction Services':
        return Icons.construction;
      case 'IT Services':
        return Icons.computer;
      default:
        return Icons.build;
    }
  }
}
