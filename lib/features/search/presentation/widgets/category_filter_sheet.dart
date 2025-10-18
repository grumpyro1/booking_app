// import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
// import 'package:booking_app/features/search/data/providers/search_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../../core/theme/app_colors.dart';


// void showCategoryFilter(
//     BuildContext context, WidgetRef ref, String? selectedCategory) {
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
//           Text('Select Category',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge
//                   ?.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           ...categories.map((category) {
//             final isSelected = selectedCategory == category['name'];
//             return ListTile(
//               leading: Icon(category['icon']),
//               title: Text(category['name']),
//               trailing:
//                   isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
//               onTap: () {
//                 ref.read(selectedCategoryFilterProvider.notifier).state =
//                     category['name'];
//                 Navigator.pop(context);
//               },
//             );
//           }),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton(
//               onPressed: () {
//                 ref.read(selectedCategoryFilterProvider.notifier).state = null;
//                 Navigator.pop(context);
//               },
//               child: const Text('Clear Filter'),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
