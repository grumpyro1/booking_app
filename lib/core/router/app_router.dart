// lib/core/router/app_router.dart

import 'package:booking_app/core/layout/scaffold_with_nav_bar.dart';
import 'package:booking_app/features/home/presentation/screens/new_home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/data/provider/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/booking/presentation/screens/my_bookings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/cart/presentation/screens/all_carts_screen.dart';
import '../../features/cart/presentation/screens/single_cart_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/booking/presentation/screens/delivery_address_screen.dart';
import '../../features/booking/presentation/screens/manage_addresses_screen.dart';
import '../../features/payment/presentation/screens/checkout_screen.dart';
import '../../features/provider/presentation/screens/provider_detail_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../core/constants/mock_providers_data.dart';

// Navigation Shell (Bottom Nav Container)

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoading = authState.isLoading;
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // Allow splash and onboarding
      if (isSplash || isOnboarding) {
        return null;
      }

      // Keep on splash while auth is loading
      if (isLoading) {
        return '/';
      }

      // Redirect to login if not logged in and not on auth pages
      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // Redirect to home if logged in and on auth pages
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main App Shell (with Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) {
          // Determine selected index based on current route
          int selectedIndex = 0;
          final location = state.matchedLocation;
          
          if (location == '/search') {
            selectedIndex = 1;
          } else if (location == '/bookings') {
            selectedIndex = 2;
          } else if (location == '/profile') {
            selectedIndex = 3;
          }

          return ScaffoldWithNavBar(
            selectedIndex: selectedIndex,
            child: child,
          );
        },
        routes: [
          // Home Tab
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Search Tab
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),

          // Bookings Tab
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const MyBookingsScreen(),
          ),

          // Profile Tab
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Provider Detail (Full Screen - No Bottom Nav)
      GoRoute(
        path: '/provider/:id',
        builder: (context, state) {
          final providerId = state.pathParameters['id']!;
          final provider = mockProviders.firstWhere(
            (p) => p.id == providerId,
            orElse: () => mockProviders.first,
          );
          return ProviderDetailScreen(provider: provider);
        },
      ),

      // Cart Routes (Full Screen)
      GoRoute(
        path: '/all-carts',
        builder: (context, state) => const AllCartsScreen(),
      ),
      GoRoute(
        path: '/single-cart/:providerId',
        builder: (context, state) {
          final providerId = state.pathParameters['providerId']!;
          return SingleCartScreen(providerId: providerId);
        },
      ),

      // Booking Routes (Full Screen)
      GoRoute(
        path: '/booking-confirmation/:providerId',
        builder: (context, state) {
          final providerId = state.pathParameters['providerId']!;
          return BookingConfirmationScreen(providerId: providerId);
        },
      ),

      // Delivery Address Route
      // GoRoute(
      //   path: '/delivery-address',
      //   builder: (context, state) {
      //     final initialAddress = state.extra as Map<String, dynamic>?;
      //     return DeliveryAddressScreen(initialAddress: initialAddress);
      //   },
      // ),

  // Delivery Address Route - UPDATED
        GoRoute(
          path: '/delivery-address',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final initialAddress = extra?['address'] as Map<String, dynamic>?;
            final isEditMode = extra?['isEditMode'] as bool? ?? false;
            final addressId = extra?['addressId'] as String?;
            
            return DeliveryAddressScreen(
              initialAddress: initialAddress,
              isEditMode: isEditMode,
              addressId: addressId,
            );
          },
        ),

      // Manage Saved Addresses Route
      GoRoute(
        path: '/manage-addresses',
        builder: (context, state) => const ManageAddressesScreen(),
      ),

      // Checkout Route
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final bookingDetails = state.extra as Map<String, dynamic>;
          return CheckoutScreen(bookingDetails: bookingDetails);
        },
      ),

      // Booking Success Route
      GoRoute(
        path: '/booking-success/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return BookingSuccessScreen(bookingId: bookingId);
        },
      ),
    ],
  );
});