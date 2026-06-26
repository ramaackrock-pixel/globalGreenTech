import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/customer/presentation/screens/customer_dashboard_screen.dart';
import 'features/staff/presentation/screens/staff_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load SharedPreferences before mounting providers
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Global Green Tech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AuthGate(),
    );
  }
}

// Router/AuthGate that handles session checking and redirects
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // If cache session is still being checked, show splash loader
    if (authState.isCheckingCache) {
      return const Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(
            color: AppTheme.primaryColor,
            size: 50.0,
          ),
        ),
      );
    }

    final user = authState.user;

    // If user session is active, route directly to role dashboard
    if (user != null) {
      switch (user.role) {
        case UserRole.admin:
          return const AdminDashboardScreen();
        case UserRole.staff:
          return const StaffDashboardScreen();
        case UserRole.customer:
          return const CustomerDashboardScreen();
        default:
          return const LoginScreen();
      }
    }

    // Default to login page
    return const LoginScreen();
  }
}
