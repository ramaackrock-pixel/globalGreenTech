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

class CustomerDashboardScreen extends ConsumerStatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  ConsumerState<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<CustomerDashboardScreen> {
  int _currentIndex = 0;

  final List<String> _pageTitles = [
    'Dashboard',
    'My Products',
    'Service Requests',
    'AMC & Billing',
    'Referrals',
    'Settings',
    'Profile',
  ];

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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    final List<Widget> views = [
      const CustomerOverviewView(),
      const CustomerProductsView(),
      const CustomerServiceView(),
      const CustomerBillingView(),
      const CustomerReferralsView(),
      const CustomerSettingsView(),
      const CustomerProfileView(),
    ];

    final navigationItems = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.water_drop_outlined),
        selectedIcon: Icon(Icons.water_drop, color: AppTheme.primaryColor),
        label: 'My Products',
      ),
      const NavigationDestination(
        icon: Icon(Icons.home_repair_service_outlined),
        selectedIcon: Icon(Icons.home_repair_service, color: AppTheme.primaryColor),
        label: 'Service',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long, color: AppTheme.primaryColor),
        label: 'Billing',
      ),
      const NavigationDestination(
        icon: Icon(Icons.card_giftcard_outlined),
        selectedIcon: Icon(Icons.card_giftcard, color: AppTheme.primaryColor),
        label: 'Referrals',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
        label: 'Settings',
      ),
    ];

    // Tablet Layout (Navigation Rail)
    if (isTablet) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _pageTitles[_currentIndex],
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: _buildHeaderActions(isDark, user?.name ?? 'Customer'),
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: isDark
                  ? AppTheme.darkSurfaceContainerLowestColor
                  : Colors.white,
              selectedLabelTextStyle: TextStyle(
                color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
              ),
              destinations: navigationItems
                  .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        selectedIcon: e.selectedIcon,
                        label: Text(e.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: views[_currentIndex],
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Layout
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _buildHeaderActions(isDark, user?.name ?? 'Customer'),
      ),
      drawer: Drawer(
        backgroundColor: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
        child: _buildDrawerContent(isDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: views[_currentIndex],
      ),
      bottomNavigationBar: _currentIndex < 3
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: navigationItems.sublist(0, 3),
            )
          : null,
    );
  }

  List<Widget> _buildHeaderActions(bool isDark, String name) {
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
              _currentIndex = 6; // Navigate to Profile
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
      _DrawerItem(Icons.receipt_long_outlined, 'AMC & Billing', 3),
      _DrawerItem(Icons.card_giftcard_outlined, 'Refer & Earn', 4),
      _DrawerItem(Icons.settings_outlined, 'Settings', 5),
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
                setState(() => _currentIndex = item.index);
                Navigator.pop(context);
              },
            )),
        const Spacer(),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: AppTheme.errorColor),
          title: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
          onTap: () {
            Navigator.pop(context);
            _handleSignOut();
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
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final int index;

  _DrawerItem(this.icon, this.label, this.index);
}
