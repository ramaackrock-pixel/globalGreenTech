import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';
import 'forgot_password_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../staff/presentation/screens/staff_dashboard_screen.dart';
import '../../../customer/presentation/screens/customer_dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).clearError();
      
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to navigate
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.user != null) {
        _navigateToDashboard(next.user!);
      }
    });

    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;

    final cardBgColor = isDark 
        ? theme.colorScheme.surface.withOpacity(0.85)
        : Colors.white.withOpacity(0.85);
    final cardBorderColor = isDark
        ? theme.colorScheme.onSurface.withOpacity(0.15)
        : Colors.white.withOpacity(0.3);

    return Scaffold(
      appBar: Navigator.canPop(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient Bubbles
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.1,
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? theme.colorScheme.primary : AppTheme.primaryColor).withOpacity(isDark ? 0.08 : 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? theme.colorScheme.secondary : AppTheme.secondaryColor).withOpacity(isDark ? 0.08 : 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),

          // Central Card container
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 900 : 450,
                  minHeight: isTablet ? 550 : 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: cardBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Left Branding Panel
                            Expanded(child: _buildBrandingPanel()),
                            // Right Login Form
                            Expanded(child: _buildLoginForm(authState)),
                          ],
                        )
                      : Column(
                          children: [
                            // Stacked Login Form
                            _buildLoginForm(authState),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Branding Panel (Wide Layout)
  Widget _buildBrandingPanel() {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryContainerColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Green Tech',
                style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),

          // Core slogan
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reaping Green\nFutures',
                style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 38,
                      height: 1.15,
                    ),
              ),
              const SizedBox(width: 40, child: Divider(color: Colors.white24, height: 40)),
              Text(
                'Streamline operations, track technicians in real-time, and provide exceptional customer service all in one premium portal.',
                style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.85),
                    ),
              ),
            ],
          ),

          // Security Alert Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: Color(0xFF6CC8FE), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Enterprise-grade security.\nAccess restricted by assigned roles.',
                    style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Login Form (Adapts to both narrow and wide layouts)
  Widget _buildLoginForm(AuthState authState) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mobile Logo (Only visible if narrow)
            if (MediaQuery.of(context).size.width <= 800) ...[
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.water_drop,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Green Tech',
                      style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],

            Text(
              'Welcome Back',
              style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to your Global Green Tech account.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Error Message Box
            if (authState.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authState.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Email Address
            Text(
              'Email Address',
              style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 6),
            AdaptiveTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.outline),
              hintText: 'Enter your email',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            AdaptiveTextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.outline),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: theme.colorScheme.outline,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: AdaptiveButton(
                onPressed: authState.isLoading ? null : _handleLogin,
                type: AdaptiveButtonType.filled,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                child: authState.isLoading
                    ? AdaptiveProgressIndicator(radius: 10, color: theme.colorScheme.onPrimary)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Sign In Securely',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamic Routing Handler based on authenticated role
  void _navigateToDashboard(UserModel user) {
    Widget dashboard;
    switch (user.role) {
      case UserRole.admin:
        dashboard = const AdminDashboardScreen();
        break;
      case UserRole.staff:
        dashboard = const StaffDashboardScreen();
        break;
      case UserRole.customer:
        dashboard = const CustomerDashboardScreen();
        break;
      default:
        // Fallback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown role account authenticated.')),
        );
        return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => dashboard),
      (route) => false,
    );
  }
}
