import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'views/staff_overview_view.dart';
import 'views/staff_tasks_view.dart';
import 'views/staff_attendance_view.dart';
import 'views/staff_salary_view.dart';
import 'views/staff_profile_view.dart';
import 'views/staff_settings_view.dart';
import 'views/staff_inventory_view.dart';
import 'views/staff_incentives_view.dart';

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  int _currentIndex = 0;

  final List<String> _pageTitles = [
    'Dashboard',
    'My Tasks',
    'Attendance',
    'Inventory',
    'Incentives',
    'Salary',
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

    final List<Widget> views = [
      const StaffOverviewView(),
      const StaffTasksView(),
      const StaffAttendanceView(),
      const StaffInventoryView(),
      const StaffIncentivesView(),
      const StaffSalaryView(),
      const StaffSettingsView(),
      const StaffProfileView(),
    ];

    final navigationItems = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.assignment_outlined),
        selectedIcon: Icon(Icons.assignment, color: AppTheme.primaryColor),
        label: 'My Tasks',
      ),
      const NavigationDestination(
        icon: Icon(Icons.fingerprint_outlined),
        selectedIcon: Icon(Icons.fingerprint, color: AppTheme.primaryColor),
        label: 'Attendance',
      ),
      const NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2, color: AppTheme.primaryColor),
        label: 'Inventory',
      ),
      const NavigationDestination(
        icon: Icon(Icons.star_outline),
        selectedIcon: Icon(Icons.star, color: AppTheme.primaryColor),
        label: 'Incentives',
      ),
      const NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        selectedIcon:
            Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
        label: 'Salary',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
        label: 'Settings',
      ),
    ];

    // 1. Tablet Responsive Layout (Side Rail Navigation)
    if (isTablet) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _pageTitles[_currentIndex],
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: _buildHeaderActions(isDark),
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
                color: isDark
                    ? AppTheme.darkPrimaryColor
                    : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: isDark
                    ? AppTheme.darkOnSurfaceVariantColor
                    : AppTheme.onSurfaceVariantColor,
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

    // 2. Mobile Layout (Bottom Nav for first 3 + Drawer for all 5)
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _buildHeaderActions(isDark),
      ),
      drawer: Drawer(
        backgroundColor:
            isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'S';
  }

  // Header actions: notification + avatar
  List<Widget> _buildHeaderActions(bool isDark) {
    final user = ref.watch(authControllerProvider).user;
    final initials = user != null ? _getInitials(user.name) : 'ST';

    return [
      IconButton(
        icon: const Badge(
          label: Text('2'),
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
              _currentIndex = 7; // Route to profile view
            });
          },
          child: CircleAvatar(
            radius: 16,
            backgroundColor: isDark
                ? AppTheme.darkPrimaryContainerColor
                : AppTheme.primaryContainerColor,
            child: Text(
              initials,
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
      _DrawerItem(Icons.assignment_outlined, 'My Tasks', 1),
      _DrawerItem(Icons.fingerprint_outlined, 'Attendance', 2),
      _DrawerItem(Icons.inventory_2_outlined, 'Inventory', 3),
      _DrawerItem(Icons.star_outline, 'Incentives', 4),
      _DrawerItem(Icons.account_balance_wallet_outlined, 'Salary', 5),
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
                child: const Icon(Icons.engineering, color: Colors.white, size: 28),
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
                    'Staff Portal',
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
          title: const Text('Sign Out',
              style: TextStyle(color: AppTheme.errorColor)),
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
