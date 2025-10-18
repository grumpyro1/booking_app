// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../../../home/presentation/screens/orig_home_screen.dart';

// // Search query provider
// final searchQueryProvider = StateProvider<String>((ref) => '');

// // Selected category filter provider
// final selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

// // Price range filter provider
// final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 500000));

// // Sort option provider
// final sortOptionProvider = StateProvider<String>((ref) => 'recommended');

// // Filtered services provider
// final filteredServicesProvider = Provider<List<Service>>((ref) {
//   final query = ref.watch(searchQueryProvider).toLowerCase();
//   final selectedCategory = ref.watch(selectedCategoryFilterProvider);
//   final priceRange = ref.watch(priceRangeProvider);
//   final sortOption = ref.watch(sortOptionProvider);

//   // Start with all services
//   List<Service> filtered = List.from(mockServices);

//   // Filter by search query
//   if (query.isNotEmpty) {
//     filtered = filtered.where((service) {
//       return service.name.toLowerCase().contains(query) ||
//           service.provider.toLowerCase().contains(query) ||
//           service.category.toLowerCase().contains(query);
//     }).toList();
//   }

//   // Filter by category
//   if (selectedCategory != null) {
//     filtered = filtered.where((service) => service.category == selectedCategory).toList();
//   }

//   // Filter by price range
//   filtered = filtered.where((service) {
//     return service.price >= priceRange.start && service.price <= priceRange.end;
//   }).toList();

//   // Sort
//   switch (sortOption) {
//     case 'price_low':
//       filtered.sort((a, b) => a.price.compareTo(b.price));
//       break;
//     case 'price_high':
//       filtered.sort((a, b) => b.price.compareTo(a.price));
//       break;
//     case 'rating':
//       filtered.sort((a, b) => b.rating.compareTo(a.rating));
//       break;
//     case 'name':
//       filtered.sort((a, b) => a.name.compareTo(b.name));
//       break;
//     case 'recommended':
//     default:
//       // Keep original order
//       break;
//   }

//   return filtered;
// });