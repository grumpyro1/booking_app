// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/data/provider/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/new_home_screen.dart';
import '../../features/cart/presentation/screens/all_carts_screen.dart';
import '../../features/cart/presentation/screens/single_cart_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // Allow splash and onboarding
      if (isSplash || isOnboarding) {
        return null;
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

      // Main Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const NewHomeScreen(),
      ),

      // Cart Routes
      GoRoute(
        path: '/all-carts',
        builder: (context, state) => const AllCartsScreen(),
      ),
      GoRoute(
        path: '/single-cart',
        builder: (context, state) {
          final providerId = state.extra as String;
          return SingleCartScreen(providerId: providerId);
        },
      ),

      // Booking Routes
      GoRoute(
        path: '/booking-confirmation',
        builder: (context, state) {
          final providerId = state.extra as String;
          return BookingConfirmationScreen(providerId: providerId);
        },
      ),
      GoRoute(
        path: '/booking-success',
        builder: (context, state) {
          final bookingId = state.extra as String;
          return BookingSuccessScreen(bookingId: bookingId);
        },
      ),
    ],
  );
});