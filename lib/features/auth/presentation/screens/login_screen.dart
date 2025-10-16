import 'package:booking_app/features/auth/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); // watches the login state (If the app is loading, if there's an error, if user is etc.)

    // Show error dialog if there's an error
    ref.listen(authProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!),backgroundColor: Colors.red)); // Clear error after showing
        Future.microtask(() => ref.read(authProvider.notifier).clearError());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Logo or App Icon
              Container(
                height: 120,
                width: 120,
                alignment: Alignment.center,
                child: Icon(Icons.spa,size: 80,color: AppColors.primary),
              ),
              
              const SizedBox(height: 24),
              
              // Welcome text
              Text(
                'Title here',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Text('Sign in to continue to Wybr Services',
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              //   textAlign: TextAlign.center,
              // ),
              
              const SizedBox(height: 40),
              
              // Login Form
              LoginForm(isLoading: authState.isLoading),
              
              const SizedBox(height: 24),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: authState.isLoading
                        ? null
                        : () => context.go('/register'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Demo credentials hint
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,size: 20,color: AppColors.info),
                        const SizedBox(width: 8),
                        Text(
                          'Demo Credentials',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold,color: AppColors.info),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: user@example.com\nPassword: password123',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace',color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}