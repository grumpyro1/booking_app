import 'package:booking_app/features/auth/data/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/orig_home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    // redirect: (context, state) {
    //   final isLoggedIn = authState.isLoggedIn;
    //   final isLoading = authState.isLoading;
      
    //   final isSplash = state.matchedLocation == '/splash';
    //   final isAuth = state.matchedLocation == '/login' || 
    //                  state.matchedLocation == '/register';

    //   // Wait for auth check to complete
    //   if (isLoading && isSplash) {
    //     return '/splash';
    //   }

    //   // Redirect to login if not authenticated
    //   if (!isLoggedIn && !isAuth && !isSplash) {
    //     return '/login';
    //   }

    //   // Redirect to home if already logged in
    //   if (isLoggedIn && (isAuth || isSplash)) {
    //     return '/home';
    //   }

    //   return null;
    // },
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoading = authState.isLoading;
      
      final isSplash = state.matchedLocation == '/splash';
      final isAuth = state.matchedLocation == '/login' || 
                    state.matchedLocation == '/register';

      // If still checking auth, stay on splash
        if (isLoading) {
          return null; // Stay where you are
        }

        // If on splash and done loading, redirect based on login status
        if (isSplash) {
          return isLoggedIn ? '/home' : '/login';
        }

        // If logged in and on auth pages, go to home
        if (isLoggedIn && isAuth) {
          return '/home';
        }

        // If not logged in and trying to access protected pages
        if (!isLoggedIn && !isAuth) {
          return '/login';
        }

        return null; // No redirect needed
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
      // GoRoute(
      //   path: '/register',
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const OrigHomeScreen(),
      ),
    ],
  );
});