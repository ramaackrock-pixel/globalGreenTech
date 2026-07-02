import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'views/customer_overview_view.dart';
import 'views/customer_products_view.dart';
import 'views/customer_service_view.dart';
import 'views/customer_billing_view.dart';
import 'views/customer_profile_view.dart';
import 'views/customer_settings_view.dart';
import 'views/customer_referrals_view.dart';
import 'views/customer_marketplace_view.dart';

class CustomerDashboardScreen extends ConsumerStatefulWidget {
  final bool isGuest;
  const CustomerDashboardScreen({super.key, this.isGuest = false});

  @override
  ConsumerState<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<CustomerDashboardScreen> {
  late int _currentIndex;
  Timer? _guestPopupTimer;

  final List<String> _pageTitles = [
    'Dashboard',
    'My Products',
    'Service Requests',
    'Water Market',
    'AMC & Billing',
    'Referrals',
    'Settings',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.isGuest ? 3 : 0;
    if (widget.isGuest) {
      _guestPopupTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          _showGuestContinueOrLoginDialog();
        }
      });
    }
  }

  @override
  void dispose() {
    _guestPopupTimer?.cancel();
    super.dispose();
  }

  void _handleSignOut() async {
    final confirmed = await AdaptiveDialog.show<bool>(
      context,
      title: 'Sign Out',
      content: 'Are you sure you want to sign out?',
      actions: [
        AdaptiveDialogAction(
          text: 'Cancel',
          onPressed: () => Navigator.pop(context, false),
        ),
        AdaptiveDialogAction(
          text: 'Sign Out',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    final List<Widget> views = [
      const CustomerOverviewView(),
      const CustomerProductsView(),
      const CustomerServiceView(),
      CustomerMarketplaceView(isGuest: widget.isGuest),
      const CustomerBillingView(),
      const CustomerReferralsView(),
      const CustomerSettingsView(),
      const CustomerProfileView(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: widget.isGuest
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.water_drop, color: AppTheme.primaryColor, size: 28),
              )
            : null,
        title: Text(
          widget.isGuest ? 'GGT Marketplace' : _pageTitles[_currentIndex],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _buildHeaderActions(isDark, user?.name ?? 'Guest User'),
      ),
      drawer: widget.isGuest
          ? null
          : Drawer(
              backgroundColor: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
              child: _buildDrawerContent(isDark),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: views[_currentIndex],
      ),
    );
  }

  List<Widget> _buildHeaderActions(bool isDark, String name) {
    if (widget.isGuest) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton.icon(
            onPressed: _redirectToLogin,
            icon: const Icon(Icons.login, color: AppTheme.primaryColor),
            label: const Text(
              'Login',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      IconButton(
        icon: const Badge(
          label: Text('1'),
          child: Icon(Icons.notifications_none_outlined),
        ),
        onPressed: () {},
      ),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 7; // Navigate to Profile
            });
          },
          child: CircleAvatar(
            radius: 16,
            backgroundColor: isDark
                ? AppTheme.darkPrimaryContainerColor
                : AppTheme.primaryContainerColor,
            child: Text(
              _getInitials(name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildDrawerContent(bool isDark) {
    final drawerItems = [
      _DrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
      _DrawerItem(Icons.water_drop_outlined, 'My Products', 1),
      _DrawerItem(Icons.home_repair_service_outlined, 'Service Requests', 2),
      _DrawerItem(Icons.storefront_outlined, 'Water Market', 3),
      _DrawerItem(Icons.receipt_long_outlined, 'AMC & Billing', 4),
      _DrawerItem(Icons.card_giftcard_outlined, 'Refer & Earn', 5),
      _DrawerItem(Icons.settings_outlined, 'Settings', 6),
    ];

    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppTheme.darkSurfaceContainerColor,
                      AppTheme.darkSurfaceContainerLowestColor,
                    ]
                  : [
                      AppTheme.primaryColor,
                      AppTheme.primaryContainerColor,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Green Tech',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Customer Portal',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...drawerItems.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              selected: _currentIndex == item.index,
              onTap: () {
                if (widget.isGuest && item.index != 3 && item.index != 6) {
                  Navigator.pop(context);
                  _showGuestLoginRequiredDialog();
                } else {
                  setState(() => _currentIndex = item.index);
                  Navigator.pop(context);
                }
              },
            )),
        const Spacer(),
        const Divider(),
        ListTile(
          leading: Icon(
            widget.isGuest ? Icons.login : Icons.logout,
            color: widget.isGuest ? AppTheme.primaryColor : AppTheme.errorColor,
          ),
          title: Text(
            widget.isGuest ? 'Login' : 'Sign Out',
            style: TextStyle(
              color: widget.isGuest ? AppTheme.primaryColor : AppTheme.errorColor,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            if (widget.isGuest) {
              _redirectToLogin();
            } else {
              _handleSignOut();
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'C';
  }

  void _showGuestContinueOrLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Welcome to Green Tech!'),
          content: const Text(
            'You are browsing as a guest. Would you like to continue exploring the marketplace or log in to access your dashboard?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue as Guest'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _redirectToLogin();
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _showGuestLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Login Required'),
          content: const Text('Please log in to access this feature, add items to your cart, and make purchases.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _redirectToLogin();
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _redirectToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final int index;

  _DrawerItem(this.icon, this.label, this.index);
}
