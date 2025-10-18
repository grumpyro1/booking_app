// import 'package:booking_app/features/search/presentation/widgets/category_filter_sheet.dart';
// import 'package:booking_app/features/search/presentation/widgets/empy_state_widget.dart';
// import 'package:booking_app/features/search/presentation/widgets/filter_chip_widget.dart';
// import 'package:booking_app/features/search/presentation/widgets/price_filter_sheet.dart';
// import 'package:booking_app/features/search/presentation/widgets/sort_options_sheet.dart';
// import 'package:booking_app/shared/widgets/service_card_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/providers/search_provider.dart';


// class SearchScreen extends ConsumerStatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   ConsumerState<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends ConsumerState<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _searchFocusNode.requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredServices = ref.watch(filteredServicesProvider);
//     final selectedCategory = ref.watch(selectedCategoryFilterProvider);
//     final sortOption = ref.watch(sortOptionProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           focusNode: _searchFocusNode,
//           decoration: InputDecoration(
//             hintText: 'Search services...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.grey[400]),
//           ),
//           onChanged: (value) =>
//               ref.read(searchQueryProvider.notifier).state = value,
//         ),
//         actions: [
//           if (_searchController.text.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//                 ref.read(searchQueryProvider.notifier).state = '';
//               },
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             color: Colors.white,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   FilterChipWidget(
//                     icon: Icons.category,
//                     label: selectedCategory ?? 'Category',
//                     isActive: selectedCategory != null,
//                     onTap: () => showCategoryFilter(context, ref, selectedCategory),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterChipWidget(
//                     icon: Icons.attach_money,
//                     label: 'Price',
//                     isActive: false,
//                     onTap: () => showPriceFilter(context, ref),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterChipWidget(
//                     icon: Icons.sort,
//                     label: getSortLabel(sortOption),
//                     isActive: sortOption != 'recommended',
//                     onTap: () => showSortOptions(context, ref),
//                   ),
//                   const SizedBox(width: 8),
//                   if (selectedCategory != null || sortOption != 'recommended')
//                     TextButton(
//                       onPressed: () {
//                         ref.read(selectedCategoryFilterProvider.notifier).state = null;
//                         ref.read(sortOptionProvider.notifier).state = 'recommended';
//                         ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 500000);
//                       },
//                       child: const Text('Clear All'),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const Divider(height: 1),
//           Expanded(
//             child: filteredServices.isEmpty
//                 ? const EmptyStateWidget()
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: filteredServices.length,
//                     itemBuilder: (context, index) => ServiceCardWidget(
//                       service: filteredServices[index],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   String getSortLabel(String sortOption) {
//     switch (sortOption) {
//       case 'price_low':
//         return 'Price: Low to High';
//       case 'price_high':
//         return 'Price: High to Low';
//       case 'rating':
//         return 'Rating';
//       case 'name':
//         return 'Name';
//       default:
//         return 'Sort';
//     }
//   }
// }
