import 'package:booking_app/features/auth/data/provider/auth_provider.dart';
import 'package:booking_app/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:booking_app/features/favorites/presentation/favorites_screen.dart';
import 'package:booking_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:booking_app/features/search/presentation/screens/search_screen.dart';
import 'package:booking_app/features/service/presentation/screens/category_services_screen.dart';
import 'package:booking_app/shared/widgets/floating_booking_summary.dart';
import 'package:booking_app/shared/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

// Updated Service data structure
class Service {
  final String id;
  final String name;
  final String category;
  final String serviceType;
  final double price;
  final String imageUrl;
  final double rating;
  final String provider;
  final String duration;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.serviceType,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.provider,
    required this.duration,
    required this.description,
  });
}

// Mock services list - Complete service catalog
final List<Service> mockServices = [
  // AIRCON SERVICES
  Service(
    id: 'AC001',
    name: 'Aircon Cleaning',
    category: 'Home Services',
    serviceType: 'Aircon Services',
    price: 500,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Cool Tech Services',
    duration: '1-2 hours',
    description: 'Professional aircon cleaning service with eco-friendly products',
  ),
  Service(
    id: 'AC002',
    name: 'Aircon Installation',
    category: 'Home Services',
    serviceType: 'Aircon Services',
    price: 1200,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.9,
    provider: 'Cool Tech Services',
    duration: '2-3 hours',
    description: 'Expert installation with warranty and free check-up',
  ),
  Service(
    id: 'AC003',
    name: 'Aircon Repair',
    category: 'Home Services',
    serviceType: 'Aircon Services',
    price: 800,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Cool Tech Services',
    duration: '1-2 hours',
    description: 'Quick diagnosis and repair of aircon issues',
  ),
  Service(
    id: 'AC004',
    name: 'Aircon Maintenance',
    category: 'Home Services',
    serviceType: 'Aircon Services',
    price: 600,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Cool Tech Services',
    duration: '1 hour',
    description: 'Regular maintenance to keep your aircon running efficiently',
  ),
  Service(
    id: 'AC005',
    name: 'Aircon Gas Refill',
    category: 'Home Services',
    serviceType: 'Aircon Services',
    price: 700,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Cool Tech Services',
    duration: '1 hour',
    description: 'Freon gas refill for optimal cooling',
  ),

  // PLUMBING SERVICES
  Service(
    id: 'PL001',
    name: 'Leak Repair',
    category: 'Home Services',
    serviceType: 'Plumbing Services',
    price: 400,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Fix Flow Plumbing',
    duration: '1-2 hours',
    description: 'Fast and reliable leak detection and repair',
  ),
  Service(
    id: 'PL002',
    name: 'Pipe Installation',
    category: 'Home Services',
    serviceType: 'Plumbing Services',
    price: 600,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Fix Flow Plumbing',
    duration: '2-3 hours',
    description: 'Quality pipe installation for water systems',
  ),
  Service(
    id: 'PL003',
    name: 'Drain Cleaning',
    category: 'Home Services',
    serviceType: 'Plumbing Services',
    price: 300,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Fix Flow Plumbing',
    duration: '1 hour',
    description: 'Unclog drains and prevent future blockages',
  ),
  Service(
    id: 'PL004',
    name: 'Toilet Repair',
    category: 'Home Services',
    serviceType: 'Plumbing Services',
    price: 450,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Fix Flow Plumbing',
    duration: '1 hour',
    description: 'Fix toilet leaks, flush issues, and more',
  ),

  // ELECTRICAL SERVICES
  Service(
    id: 'EL001',
    name: 'Wiring Installation',
    category: 'Home Services',
    serviceType: 'Electrical Services',
    price: 800,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.9,
    provider: 'Spark Electrical',
    duration: '2-4 hours',
    description: 'Safe and certified electrical wiring',
  ),
  Service(
    id: 'EL002',
    name: 'Lighting Setup',
    category: 'Home Services',
    serviceType: 'Electrical Services',
    price: 500,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Spark Electrical',
    duration: '1-2 hours',
    description: 'Install and configure lighting fixtures',
  ),
  Service(
    id: 'EL003',
    name: 'Outlet Repair',
    category: 'Home Services',
    serviceType: 'Electrical Services',
    price: 350,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Spark Electrical',
    duration: '30 mins - 1 hour',
    description: 'Fix faulty electrical outlets safely',
  ),

  // APPLIANCE REPAIR
  Service(
    id: 'AR001',
    name: 'Refrigerator Repair',
    category: 'Maintenance & Repair',
    serviceType: 'Appliance Repair',
    price: 700,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Home Fix Experts',
    duration: '1-2 hours',
    description: 'Expert refrigerator troubleshooting and repair',
  ),
  Service(
    id: 'AR002',
    name: 'Washing Machine Repair',
    category: 'Maintenance & Repair',
    serviceType: 'Appliance Repair',
    price: 650,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Home Fix Experts',
    duration: '1-2 hours',
    description: 'Fix washing machine issues quickly',
  ),
  Service(
    id: 'AR003',
    name: 'TV Repair',
    category: 'Maintenance & Repair',
    serviceType: 'Appliance Repair',
    price: 800,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Home Fix Experts',
    duration: '1-2 hours',
    description: 'Television repair and troubleshooting',
  ),

  // HOUSE CLEANING
  Service(
    id: 'HC001',
    name: 'General Cleaning',
    category: 'Cleaning & Sanitation',
    serviceType: 'House Cleaning',
    price: 400,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.9,
    provider: 'Sparkle Clean Co.',
    duration: '2-3 hours',
    description: 'Thorough cleaning of your entire home',
  ),
  Service(
    id: 'HC002',
    name: 'Deep Cleaning',
    category: 'Cleaning & Sanitation',
    serviceType: 'House Cleaning',
    price: 800,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.9,
    provider: 'Sparkle Clean Co.',
    duration: '4-6 hours',
    description: 'Intensive cleaning including hard-to-reach areas',
  ),
  Service(
    id: 'HC003',
    name: 'Post-Construction Cleaning',
    category: 'Cleaning & Sanitation',
    serviceType: 'House Cleaning',
    price: 1200,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Sparkle Clean Co.',
    duration: '4-8 hours',
    description: 'Remove construction debris and dust',
  ),

  // PAINTING SERVICES
  Service(
    id: 'PT001',
    name: 'Interior Painting',
    category: 'Construction & Renovation',
    serviceType: 'Painting Services',
    price: 1500,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Color Masters',
    duration: '1-2 days',
    description: 'Professional interior painting with quality materials',
  ),
  Service(
    id: 'PT002',
    name: 'Exterior Painting',
    category: 'Construction & Renovation',
    serviceType: 'Painting Services',
    price: 2000,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Color Masters',
    duration: '2-3 days',
    description: 'Weather-resistant exterior painting',
  ),

  // PEST CONTROL
  Service(
    id: 'PC001',
    name: 'Termite Control',
    category: 'Maintenance & Repair',
    serviceType: 'Pest Control',
    price: 900,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Pest Away',
    duration: '2-3 hours',
    description: 'Effective termite treatment and prevention',
  ),
  Service(
    id: 'PC002',
    name: 'Cockroach Control',
    category: 'Maintenance & Repair',
    serviceType: 'Pest Control',
    price: 600,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Pest Away',
    duration: '1-2 hours',
    description: 'Eliminate cockroach infestation safely',
  ),

  // HANDYMAN SERVICES
  Service(
    id: 'HM001',
    name: 'Fixture Installation',
    category: 'Maintenance & Repair',
    serviceType: 'Handyman Services',
    price: 350,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.7,
    provider: 'Jack of All Trades',
    duration: '1 hour',
    description: 'Install shelves, mirrors, and fixtures',
  ),
  Service(
    id: 'HM002',
    name: 'Minor Repairs',
    category: 'Maintenance & Repair',
    serviceType: 'Handyman Services',
    price: 300,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.6,
    provider: 'Jack of All Trades',
    duration: '30 mins - 1 hour',
    description: 'Quick fixes for household issues',
  ),
  Service(
    id: 'HM003',
    name: 'TV Mounting',
    category: 'Maintenance & Repair',
    serviceType: 'Handyman Services',
    price: 400,
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.8,
    provider: 'Jack of All Trades',
    duration: '1 hour',
    description: 'Professional TV wall mounting service',
  ),
];

// Updated Categories
final List<Map<String, dynamic>> categories = [
  {'name': 'Home Services', 'icon': Icons.home_repair_service},
  {'name': 'Maintenance & Repair', 'icon': Icons.build},
  {'name': 'Cleaning & Sanitation', 'icon': Icons.cleaning_services},
  {'name': 'Construction & Renovation', 'icon': Icons.construction},
  {'name': 'Outdoor & Gardening', 'icon': Icons.grass},
  {'name': 'Security & Technology', 'icon': Icons.security},
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
      const SearchScreen(),
      const MyBookingsScreen(),
      const ProfileScreen(),
    ];
    
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

// Home Tab Content// Home Tab Content
class HomeTabContent extends ConsumerWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('SerbisyoKo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications - Coming soon')),
                  );
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What service do you need today?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                            context.push(
                              '/category/${Uri.encodeComponent(category['name'])}?icon=${(category['icon'] as IconData).codePoint}',
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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

                // Services List - Show top 6
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final service = mockServices[index];
                    return ServiceCardWidget(service: service);
                  },
                ),

                const SizedBox(height: 100), // Extra space for floating button
              ],
            ),
          ),
        ),
        // Floating Booking Summary
        FloatingBookingSummary(),
      ],
    );
  }
}