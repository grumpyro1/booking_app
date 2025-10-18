// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../auth/data/provider/auth_provider.dart';
// import '../../../favorites/presentation/favorites_screen.dart';

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authProvider);
//     final user = authState.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           // Profile Header
//           Center(
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: AppColors.primary.withOpacity(0.2),
//                   child: Text(
//                     user?.name?.substring(0, 1).toUpperCase() ?? 'U',
//                     style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   user?.name ?? 'User',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   user?.email ?? '',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 32),

//           // Menu Items
//           ListTile(
//             leading: const Icon(Icons.person_outline),
//             title: const Text('Edit Profile'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Edit Profile - Coming soon')),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.favorite_outline),
//             title: const Text('Favorites'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const FavoritesScreen(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.payment_outlined),
//             title: const Text('Payment Methods'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Payment Methods - Coming soon')),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings_outlined),
//             title: const Text('Settings'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Settings - Coming soon')),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.help_outline),
//             title: const Text('Help & Support'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Help & Support - Coming soon')),
//               );
//             },
//           ),

//           const SizedBox(height: 16),

//           // Logout Button
//           OutlinedButton.icon(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Logout'),
//                   content: const Text('Are you sure you want to logout?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         ref.read(authProvider.notifier).logout();
//                       },
//                       child: const Text('Logout'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             icon: const Icon(Icons.logout),
//             label: const Text('Logout'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.red,
//               side: const BorderSide(color: Colors.red),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }