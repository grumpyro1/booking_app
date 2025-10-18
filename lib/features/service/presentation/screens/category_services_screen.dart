// import 'package:booking_app/features/home/presentation/screens/orig_home_screen.dart';
// import 'package:booking_app/shared/widgets/service_card_widget.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';

// class CategoryServicesScreen extends StatelessWidget {
//   final String categoryName;
//   final IconData categoryIcon;

//   const CategoryServicesScreen({
//     super.key,
//     required this.categoryName,
//     required this.categoryIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Filter services by category
//     final filteredServices = mockServices.where((service) => service.category == categoryName).toList();

//     return Scaffold(
//       appBar: AppBar(title: Text(categoryName)),
//       body: filteredServices.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     categoryIcon,
//                     size: 100,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No services available',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Check back later for new services',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//             )
//           : ListView(
//               padding: const EdgeInsets.all(20),
//               children: [
//                 // Category Header
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           categoryIcon,
//                           color: AppColors.primary,
//                           size: 32,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               categoryName,
//                               style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${filteredServices.length} services available',
//                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Services List
//                 ...filteredServices.map((service) {
//                   return ServiceCardWidget(service: service);
//                 }).toList(),
//               ],
//             ),
//     );
//   }
// }