import 'package:booking_app/features/auth/data/provider/auth_provider.dart';
import 'package:booking_app/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:booking_app/features/favorites/presentation/favorites_screen.dart';
import 'package:booking_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:booking_app/features/search/presentation/screens/search_screen.dart';
import 'package:booking_app/features/service/presentation/screens/category_services_screen.dart';
import 'package:booking_app/shared/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/theme/app_colors.dart';

// Dummy service data
class Service {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final String provider;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.provider,
  });
}

// Mock services list
final List<Service> mockServices = [
  Service(
    id: '1',
    name: 'Balinese Massage',
    category: 'Spa & Wellness',
    price: 250000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Spa Bali Indah',
  ),
  Service(
    id: '2',
    name: 'Traditional Dance Class',
    category: 'Culture & Arts',
    price: 150000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.5,
    provider: 'Bali Arts Center',
  ),
  Service(
    id: '3',
    name: 'Surfing Lesson',
    category: 'Sports & Activities',
    price: 300000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.9,
    provider: 'Bali Surf School',
  ),
  Service(
    id: '4',
    name: 'Cooking Class',
    category: 'Food & Culinary',
    price: 200000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Warung Bali Cooking',
  ),
  Service(
    id: '5',
    name: 'Yoga Session',
    category: 'Spa & Wellness',
    price: 150000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Ubud Yoga Studio',
  ),
  Service(
    id: '6',
    name: 'Temple Tour Guide',
    category: 'Tours & Travel',
    price: 350000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Bali Heritage Tours',
  ),
];

// Categories
final List<Map<String, dynamic>> categories = [
  {'name': 'Spa & Wellness', 'icon': Icons.spa},
  {'name': 'Culture & Arts', 'icon': Icons.palette},
  {'name': 'Sports & Activities', 'icon': Icons.surfing},
  {'name': 'Food & Culinary', 'icon': Icons.restaurant},
  {'name': 'Tours & Travel', 'icon': Icons.tour},
  {'name': 'Beauty & Care', 'icon': Icons.face},
];

// Provider for selected index
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class OrigHomeScreen extends ConsumerWidget {
  const OrigHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    // List of pages for each tab
    final List<Widget> pages = [
      const HomeTabContent(),
      SearchScreen(),
      MyBookingsScreen(),
      ProfileScreen(),
      // const ProfileTabContent(),
    ];
    // navbar with 4 tabs: Home, Search, Bookings, Profile
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Tab Content
class HomeTabContent extends ConsumerWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SerbisyoKo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications - Coming soon')));
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.name?.split(' ').first ?? 'User'}! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What service do you need today?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    readOnly: true,
                    onTap: () {
                      ref.read(selectedIndexProvider.notifier).state = 1;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Categories Section

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    width: 90,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryServicesScreen(
                              categoryName: category['name'],
                              categoryIcon: category['icon'],
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1),borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              category['icon'],
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Popular Services Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(selectedIndexProvider.notifier).state = 1;
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Services List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: mockServices.length,
              itemBuilder: (context, index) {
                final service = mockServices[index];
                return ServiceCardWidget(service: service);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
