import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'views/admin_overview_view.dart';
import 'views/admin_users_view.dart';
import 'views/admin_customers_view.dart';
import 'views/admin_tasks_view.dart';
import 'views/admin_inventory_view.dart';
import 'views/admin_payroll_view.dart';
import 'views/admin_settings_view.dart';
import 'views/admin_attendance_view.dart';
import 'views/admin_photos_view.dart';

// Search Query State Provider
final adminSearchQueryProvider = StateProvider<String>((ref) => '');

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _pageTitles = [
    'Dashboard',
    'Staff Attendance',
    'Job Gallery',
    'User Accounts',
    'Customers & AMC',
    'Service Tasks',
    'Inventory Management',
    'Employee Payroll',
    'Settings',
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Widget> views = [
      const AdminOverviewView(),
      const AdminAttendanceView(),
      const AdminPhotosView(),
      const AdminUsersView(),
      const AdminCustomersView(),
      const AdminTasksView(),
      const AdminInventoryView(),
      const AdminPayrollView(),
      const AdminSettingsView(),
    ];

    final navigationItems = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        selectedIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
        label: 'Attendance',
      ),
      const NavigationDestination(
        icon: Icon(Icons.collections_outlined),
        selectedIcon: Icon(Icons.collections, color: AppTheme.primaryColor),
        label: 'Gallery',
      ),
      const NavigationDestination(
        icon: Icon(Icons.shield_outlined),
        selectedIcon: Icon(Icons.shield, color: AppTheme.primaryColor),
        label: 'Users',
      ),
      const NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people, color: AppTheme.primaryColor),
        label: 'Customers',
      ),
      const NavigationDestination(
        icon: Icon(Icons.assignment_outlined),
        selectedIcon: Icon(Icons.assignment, color: AppTheme.primaryColor),
        label: 'Tasks',
      ),
      const NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2, color: AppTheme.primaryColor),
        label: 'Inventory',
      ),
      const NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
        label: 'Payroll',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
        label: 'Settings',
      ),
    ];

    // 1. Tablet Responsive Layout (Side Rail Navigation - same for both platforms)
    if (isTablet) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _pageTitles[_currentIndex],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: _buildHeaderActions(isTablet, isDark),
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _searchController.clear();
                  ref.read(adminSearchQueryProvider.notifier).state = '';
                });
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
              selectedLabelTextStyle: TextStyle(
                color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
              ),
              destinations: navigationItems
                  .map(
                    (e) => NavigationRailDestination(
                      icon: e.icon,
                      selectedIcon: e.selectedIcon,
                      label: Text(e.label),
                    ),
                  )
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

    // 2. Mobile Scaffold (both iOS and Android)
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: _buildHeaderActions(false, isDark),
      ),
      drawer: Drawer(
        backgroundColor: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
        child: _buildDrawerContent(isDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: views[_currentIndex],
      ),
    );
  }

  // Header Search and Notification actions
  List<Widget> _buildHeaderActions(bool isTablet, bool isDark) {
    return [
      if (_currentIndex != 0 && _currentIndex != 8)
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: SizedBox(
            width: isTablet ? 300 : 150,
            height: 38,
            child: TextField(
              controller: _searchController,
              onChanged: (val) => ref.read(adminSearchQueryProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, size: 16),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: isDark ? AppTheme.darkSurfaceContainerColor : AppTheme.surfaceContainerColor.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
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
        child: CircleAvatar(
          radius: 16,
          backgroundColor: isDark ? AppTheme.darkPrimaryContainerColor : AppTheme.primaryContainerColor,
          child: Text(
            'AU',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ];
  }


  Widget _buildDrawerContent(bool isDark) {
    final drawerItems = [
      _DrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
      _DrawerItem(Icons.calendar_month_outlined, 'Staff Attendance', 1),
      _DrawerItem(Icons.collections_outlined, 'Job Gallery', 2),
      _DrawerItem(Icons.shield_outlined, 'User Accounts', 3),
      _DrawerItem(Icons.people_outline, 'Customers & AMC', 4),
      _DrawerItem(Icons.assignment_outlined, 'Service Tasks', 5),
      _DrawerItem(Icons.inventory_2_outlined, 'Inventory Management', 6),
      _DrawerItem(Icons.account_balance_wallet_outlined, 'Employee Payroll', 7),
      _DrawerItem(Icons.settings_outlined, 'Settings', 8),
    ];

    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppTheme.darkSurfaceContainerColor, AppTheme.darkSurfaceContainerLowestColor]
                  : [AppTheme.primaryColor, AppTheme.primaryContainerColor],
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
                    'Admin Portal',
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
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ...drawerItems.map((item) => ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.label),
                    selected: _currentIndex == item.index,
                    onTap: () {
                      setState(() {
                        _currentIndex = item.index;
                        _searchController.clear();
                        ref.read(adminSearchQueryProvider.notifier).state = '';
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
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
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final int index;

  _DrawerItem(this.icon, this.label, this.index);
}
