// import 'package:booking_app/features/search/data/providers/search_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../../core/theme/app_colors.dart';

// void showSortOptions(BuildContext context, WidgetRef ref) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Sort By',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           ...[
//             {'label': 'Recommended', 'value': 'recommended'},
//             {'label': 'Price: Low to High', 'value': 'price_low'},
//             {'label': 'Price: High to Low', 'value': 'price_high'},
//             {'label': 'Rating', 'value': 'rating'},
//             {'label': 'Name', 'value': 'name'},
//           ].map((opt) => _buildSortOption(context, ref, opt['label']!, opt['value']!)),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildSortOption(
//     BuildContext context, WidgetRef ref, String label, String value) {
//   final currentSort = ref.watch(sortOptionProvider);
//   final isSelected = currentSort == value;
//   return ListTile(
//     title: Text(label,
//         style: TextStyle(
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             color: isSelected ? AppColors.primary : null)),
//     trailing:
//         isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
//     onTap: () {
//       ref.read(sortOptionProvider.notifier).state = value;
//       Navigator.pop(context);
//     },
//   );
// }
