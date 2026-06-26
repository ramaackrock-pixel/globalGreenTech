import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../auth/presentation/screens/login_screen.dart';
import '../../../../../core/widgets/adaptive/adaptive_widgets.dart';

class StaffProfileView extends ConsumerWidget {
  const StaffProfileView({super.key});

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
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
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Profile Avatar Card
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppTheme.darkPrimaryContainerColor,
                                AppTheme.darkSurfaceContainerColor,
                              ]
                            : [
                                AppTheme.primaryColor,
                                AppTheme.primaryContainerColor,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getInitials(user?.name ?? 'Staff'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Staff Technician',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppTheme.darkPrimaryColor
                              : AppTheme.primaryColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role.toShortString().toUpperCase() ?? 'STAFF',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.darkPrimaryColor
                            : AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info Section
          Card(
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: user?.email ?? 'staff@gmail.com',
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppTheme.darkOutlineVariantColor.withOpacity(0.3)
                      : AppTheme.outlineVariantColor.withOpacity(0.5),
                ),
                _buildInfoTile(
                  icon: Icons.badge_outlined,
                  title: 'Employee ID',
                  value: user?.id ?? 's1',
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppTheme.darkOutlineVariantColor.withOpacity(0.3)
                      : AppTheme.outlineVariantColor.withOpacity(0.5),
                ),
                _buildInfoTile(
                  icon: Icons.engineering_outlined,
                  title: 'Role',
                  value: 'Field Technician',
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppTheme.darkOutlineVariantColor.withOpacity(0.3)
                      : AppTheme.outlineVariantColor.withOpacity(0.5),
                ),
                _buildInfoTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  value: '+1122334455',
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Actions Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.help_outline,
                      color: isDark
                          ? AppTheme.darkOnSurfaceVariantColor
                          : AppTheme.onSurfaceVariantColor),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppTheme.darkOutlineVariantColor.withOpacity(0.3)
                      : AppTheme.outlineVariantColor.withOpacity(0.5),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined,
                      color: isDark
                          ? AppTheme.darkOnSurfaceVariantColor
                          : AppTheme.onSurfaceVariantColor),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppTheme.darkOutlineVariantColor.withOpacity(0.3)
                      : AppTheme.outlineVariantColor.withOpacity(0.5),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline,
                      color: isDark
                          ? AppTheme.darkOnSurfaceVariantColor
                          : AppTheme.onSurfaceVariantColor),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sign Out
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleSignOut(context, ref),
              icon: const Icon(Icons.logout, size: 18, color: AppTheme.errorColor),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // App version
          Text(
            'Global Green Tech v1.0.0',
            style: TextStyle(
              color: isDark
                  ? AppTheme.darkOutlineColor
                  : AppTheme.outlineColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
              .withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 20,
            color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isDark
              ? AppTheme.darkOnSurfaceVariantColor
              : AppTheme.onSurfaceVariantColor,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'S';
  }
}
