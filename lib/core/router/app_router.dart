import 'package:booking_app/features/auth/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/orig_home_screen.dart';
import '../../features/service/presentation/screens/category_services_screen.dart';
import '../../features/service/presentation/screens/service_detail_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/booking/presentation/screens/checkout_screen.dart';
import '../../features/booking/presentation/screens/confirmation_screen.dart';
import '../../features/booking/presentation/screens/booking_cart_screen.dart';
import '../../features/booking/presentation/screens/booking_schedule_screen.dart';
import '../../features/booking/presentation/screens/checkout_multi_screen.dart';
import '../../features/booking/presentation/screens/confirmation_multi_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/booking/data/models/booking_cart_item.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoading = authState.isLoading;
      
      final isSplash = state.matchedLocation == '/splash';
      final isAuth = state.matchedLocation == '/login' || 
                    state.matchedLocation == '/register';

      if (isLoading) {
        return null;
      }

      if (isSplash) {
        return isLoggedIn ? '/home' : '/login';
      }

      if (isLoggedIn && isAuth) {
        return '/home';
      }

      if (!isLoggedIn && !isAuth) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const OrigHomeScreen(),
      ),
      
      // Category Services
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          final iconCodePoint = state.uri.queryParameters['icon'];
          return CategoryServicesScreen(
            categoryName: categoryName,
            categoryIcon: iconCodePoint != null 
                ? IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons')
                : Icons.category,
          );
        },
      ),
      
      // Service Detail
      GoRoute(
        path: '/service/:serviceId',
        builder: (context, state) {
          final service = state.extra as Service;
          return ServiceDetailScreen(service: service);
        },
      ),
      
      // NEW: Booking Cart
      GoRoute(
        path: '/booking-cart',
        builder: (context, state) => const BookingCartScreen(),
      ),
      
      // NEW: Booking Schedule (for multiple services)
      GoRoute(
        path: '/booking-schedule',
        builder: (context, state) => const BookingScheduleScreen(),
      ),
      
      // NEW: Multi-Service Checkout
      GoRoute(
        path: '/checkout-multi',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return CheckoutMultiScreen(
            cartItems: params['cartItems'] as List<BookingCartItem>,
            selectedDate: params['selectedDate'] as DateTime,
            selectedTime: params['selectedTime'] as String,
            notes: params['notes'] as String,
          );
        },
      ),
      
      // NEW: Multi-Service Confirmation
      GoRoute(
        path: '/confirmation-multi',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return ConfirmationMultiScreen(
            cartItems: params['cartItems'] as List<BookingCartItem>,
            selectedDate: params['selectedDate'] as DateTime,
            selectedTime: params['selectedTime'] as String,
            total: params['total'] as double,
            bookingId: params['bookingId'] as String,
          );
        },
      ),
      
      // OLD: Single Service Booking Flow (Keep for backward compatibility)
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final service = state.extra as Service;
          return BookingScreen(service: service);
        },
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return CheckoutScreen(
            service: params['service'] as Service,
            selectedDate: params['selectedDate'] as DateTime,
            selectedTime: params['selectedTime'] as String,
            notes: params['notes'] as String,
          );
        },
      ),
      GoRoute(
        path: '/confirmation',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return ConfirmationScreen(
            service: params['service'] as Service,
            selectedDate: params['selectedDate'] as DateTime,
            selectedTime: params['selectedTime'] as String,
            total: params['total'] as double,
            bookingId: params['bookingId'] as String,
          );
        },
      ),
      
      // Favorites
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      
      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});