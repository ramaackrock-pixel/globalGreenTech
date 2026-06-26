import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/customer_controller.dart';

class CustomerOverviewView extends ConsumerWidget {
  const CustomerOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashState = ref.watch(customerDashboardProvider);
    final requestsState = ref.watch(customerServiceRequestsProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (dashState.isLoading || requestsState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (dashState.error != null) {
      return Center(child: Text('Error: ${dashState.error}'));
    }

    final m = dashState.metrics;
    if (m == null) return const SizedBox();

    final activeRequests = requestsState.requests
        .where((r) => r.status != 'Resolved')
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(customerDashboardProvider.notifier).fetchDashboard();
        ref.read(customerServiceRequestsProvider.notifier).fetchServiceRequests();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards 2×2
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 1.4 : 1.25,
              children: [
                _buildKpiCard(
                  context: context,
                  title: "My Systems",
                  value: m.installedSystems.toString(),
                  icon: Icons.water_drop_outlined,
                  color: AppTheme.primaryColor,
                  bgColor: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                      .withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Warranty Status',
                  value: m.warrantyStatus,
                  icon: Icons.verified_user_outlined,
                  color: const Color(0xFF2E7D32),
                  bgColor: const Color(0xFF2E7D32).withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Referral Earnings',
                  value: '₹ ${m.referralBonus.toStringAsFixed(0)}',
                  icon: Icons.card_giftcard_outlined,
                  color: AppTheme.tertiaryColor,
                  bgColor: (isDark ? AppTheme.darkTertiaryColor : AppTheme.tertiaryColor)
                      .withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Open Issues',
                  value: m.openComplaints.toString(),
                  icon: Icons.report_problem_outlined,
                  color: m.openComplaints > 0 ? AppTheme.errorColor : AppTheme.secondaryColor,
                  bgColor: (m.openComplaints > 0 ? AppTheme.errorColor : AppTheme.secondaryColor)
                      .withOpacity(0.08),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // AMC Card status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.security, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Annual Maintenance Contract',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m.amcStatus,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppTheme.darkOnSurfaceVariantColor
                                      : AppTheme.onSurfaceVariantColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Scheduled Service',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppTheme.darkOnSurfaceVariantColor
                                      : AppTheme.onSurfaceVariantColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.nextServiceDate,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.schedule, size: 16),
                          label: const Text('Reschedule'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Active Service Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Service Requests',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (activeRequests.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No active complaints or service visits.',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.darkOnSurfaceVariantColor
                            : AppTheme.onSurfaceVariantColor,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...activeRequests.map((req) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getRequestColor(req.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getRequestIcon(req.type),
                          color: _getRequestColor(req.type),
                          size: 22,
                        ),
                      ),
                      title: Text(
                        req.type,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        req.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTheme.darkOnSurfaceVariantColor
                              : AppTheme.onSurfaceVariantColor,
                        ),
                      ),
                      trailing: _buildStatusChip(req.status, isDark),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? AppTheme.darkOnSurfaceVariantColor
                    : AppTheme.onSurfaceVariantColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color chipColor;
    switch (status) {
      case 'Resolved':
        chipColor = const Color(0xFF2E7D32);
        break;
      case 'In Progress':
        chipColor = AppTheme.tertiaryColor;
        break;
      case 'Scheduled':
        chipColor = AppTheme.secondaryColor;
        break;
      default:
        chipColor = AppTheme.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getRequestIcon(String type) {
    switch (type) {
      case 'Complaint':
        return Icons.warning_amber_outlined;
      case 'AMC Visit':
        return Icons.build_outlined;
      case 'Installation':
        return Icons.construction_outlined;
      default:
        return Icons.task_outlined;
    }
  }

  Color _getRequestColor(String type) {
    switch (type) {
      case 'Complaint':
        return AppTheme.errorColor;
      case 'AMC Visit':
        return AppTheme.secondaryColor;
      case 'Installation':
        return AppTheme.tertiaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
