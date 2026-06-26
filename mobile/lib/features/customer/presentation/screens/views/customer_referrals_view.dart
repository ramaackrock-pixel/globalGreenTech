import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../presentation/controllers/customer_controller.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';

class CustomerReferralsView extends ConsumerWidget {
  const CustomerReferralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final userId = user?.id ?? 'c1';
    final referralCode = 'GGT-$userId-500';

    final dashState = ref.watch(customerDashboardProvider);
    final metrics = dashState.metrics;
    
    // Get bonus from metrics or fallback to default
    final double earned = metrics?.referralBonus ?? 1500.0;
    final int referralCount = (earned / 500.0).round();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(customerDashboardProvider.notifier).fetchDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppTheme.darkPrimaryContainerColor,
                          AppTheme.darkPrimaryColor.withOpacity(0.5),
                        ]
                      : [
                          AppTheme.primaryColor,
                          AppTheme.primaryContainerColor,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : AppTheme.primaryColor).withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer & Earn Rewards!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Invite your network to Global Green Tech and earn ₹500 off your next AMC or service visit for every successful referral.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Referral Code Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Unique Referral Code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Share this code with friends. When they sign up and book a service, you both get ₹500 off!',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Code Area & Copy Button
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkSurfaceContainerColor
                            : AppTheme.surfaceContainerColor,
                        border: Border.all(
                          color: isDark
                              ? AppTheme.darkOutlineVariantColor.withOpacity(0.5)
                              : AppTheme.outlineVariantColor.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              referralCode,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: 16,
                                color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                            tooltip: 'Copy Referral Code',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: referralCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Referral code copied to clipboard!'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Share Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          final text = 'Hey! I highly recommend Global Green Tech for your RO systems. Use my referral code to get a ₹500 discount on your first service: $referralCode';
                          debugPrint(text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Sharing referral message...'),
                              action: SnackBarAction(
                                label: 'WhatsApp',
                                onPressed: () {
                                  // In real app, launch WhatsApp
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share Code', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referrals Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context: context,
                            label: 'Total Referrals',
                            value: referralCount.toString(),
                            icon: Icons.group_outlined,
                            iconColor: isDark ? AppTheme.darkSecondaryColor : AppTheme.secondaryColor,
                            isDark: isDark,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 64,
                          color: isDark ? AppTheme.darkOutlineVariantColor.withOpacity(0.3) : AppTheme.outlineVariantColor.withOpacity(0.5),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context: context,
                            label: 'Rewards Earned',
                            value: '₹ ${earned.toStringAsFixed(0)}',
                            icon: Icons.monetization_on_outlined,
                            iconColor: Colors.amber[700]!,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
