import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';

class AdminSettingsView extends ConsumerStatefulWidget {
  const AdminSettingsView({super.key});

  @override
  ConsumerState<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends ConsumerState<AdminSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() {
    setState(() {
      _successMessage = null;
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() => _errorMessage = 'New passwords do not match.');
        return;
      }
      if (_newPasswordController.text.length < 6) {
        setState(() => _errorMessage = 'Password must be at least 6 characters.');
        return;
      }

      // Simulated API request
      setState(() {
        _successMessage = 'Password successfully updated.';
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Header
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurfaceColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your application theme, password, and security preferences.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),

              // Theme Customization Card
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Title Header
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.15)),
                            ),
                            child: Icon(
                              themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Theme Customization',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Choose your preferred application theme mode.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Theme Options
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            title: const Text('System Default'),
                            subtitle: const Text('Use system theme setting.'),
                            value: ThemeMode.system,
                            groupValue: themeMode,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                ref.read(themeModeProvider.notifier).setTheme(value);
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Light Mode'),
                            subtitle: const Text('Clean and bright appearance.'),
                            value: ThemeMode.light,
                            groupValue: themeMode,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                ref.read(themeModeProvider.notifier).setTheme(value);
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Friendly for night and low-light environments.'),
                            value: ThemeMode.dark,
                            groupValue: themeMode,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (ThemeMode? value) {
                              if (value != null) {
                                ref.read(themeModeProvider.notifier).setTheme(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Change Password Card
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Title Header
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.15)),
                            ),
                            child: const Icon(Icons.key_outlined, color: AppTheme.primaryColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Change Password',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Ensure your account is using a long, random password to stay secure.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Password Form
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Notification Boxes
                            if (_successMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _successMessage!,
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.errorColor.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: AppTheme.errorColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Current Password Field
                            Text(
                              'Current Password',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onSurfaceColor,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: isTablet ? size.width * 0.45 : double.infinity,
                              child: TextFormField(
                                controller: _currentPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(hintText: 'Enter current password'),
                                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // New Password Field
                            Text(
                              'New Password',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onSurfaceColor,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: isTablet ? size.width * 0.45 : double.infinity,
                              child: TextFormField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(hintText: 'Enter new password'),
                                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Retype New Password Field
                            Text(
                              'Retype New Password',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onSurfaceColor,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: isTablet ? size.width * 0.45 : double.infinity,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(hintText: 'Retype new password'),
                                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Action button
                            SizedBox(
                              width: isTablet ? size.width * 0.45 : double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _handleUpdatePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryContainerColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Update Password',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
