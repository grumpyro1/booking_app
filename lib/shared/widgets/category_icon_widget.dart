import 'package:flutter/material.dart';

class CategoryIconHelper {
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Textile & Fabric Items':
        return Icons.checkroom;
      case 'Traditional Clothing':
        return Icons.style;
      case 'Wearable Accessories':
        return Icons.shopping_bag;
      case 'Home & Lifestyle':
        return Icons.home;
      case 'Tech Accessories':
        return Icons.laptop;
      case 'Shawls & Wraps':
        return Icons.accessibility_new;
      case 'Bags & Carriers':
        return Icons.backpack;
      default:
        return Icons.shopping_basket;
    }
  }
}

// ============================================================================
// OLD CATEGORY ICONS (COMMENTED OUT FOR REFERENCE)
// ============================================================================

// class CategoryIconHelper {
//   static IconData getCategoryIcon(String category) {
//     switch (category) {
//       case 'Aircon Services':
//         return Icons.ac_unit;
//       case 'Plumbing Services':
//         return Icons.plumbing;
//       case 'Electrical Services':
//         return Icons.electrical_services;
//       case 'Car Services':
//         return Icons.directions_car;
//       case 'Appliance Services':
//         return Icons.kitchen;
//       case 'Construction Services':
//         return Icons.construction;
//       case 'IT Services':
//         return Icons.computer;
//       default:
//         return Icons.build;
//     }
//   }
// }