import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/staff_controller.dart';

class StaffOverviewView extends ConsumerWidget {
  const StaffOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashState = ref.watch(staffDashboardProvider);
    final tasksState = ref.watch(staffTasksProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (dashState.isLoading || tasksState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (dashState.error != null) {
      return Center(child: Text('Error: ${dashState.error}'));
    }

    final m = dashState.metrics;
    if (m == null) return const SizedBox();

    final recentTasks = tasksState.tasks.take(3).toList();
    final incentivePercent =
        m.salesTarget > 0 ? (m.incentiveEarned / m.salesTarget).clamp(0.0, 1.0) : 0.0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(staffDashboardProvider.notifier).fetchDashboard();
        ref.read(staffTasksProvider.notifier).fetchTasks();
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
                  title: "Today's Tasks",
                  value: m.todayTasks.toString(),
                  icon: Icons.assignment_outlined,
                  color: AppTheme.primaryColor,
                  bgColor: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                      .withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Completed',
                  value: m.completedTasks.toString(),
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF2E7D32),
                  bgColor: const Color(0xFF2E7D32).withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Incentive',
                  value: '₹ ${m.incentiveEarned.toStringAsFixed(0)}',
                  icon: Icons.trending_up_outlined,
                  color: AppTheme.tertiaryColor,
                  bgColor: (isDark ? AppTheme.darkTertiaryColor : AppTheme.tertiaryColor)
                      .withOpacity(0.08),
                ),
                _buildKpiCard(
                  context: context,
                  title: 'Check-in',
                  value: m.checkInTime,
                  icon: m.isCheckedIn
                      ? Icons.login_outlined
                      : Icons.logout_outlined,
                  color: m.isCheckedIn
                      ? const Color(0xFF2E7D32)
                      : AppTheme.errorColor,
                  bgColor: (m.isCheckedIn
                          ? const Color(0xFF2E7D32)
                          : AppTheme.errorColor)
                      .withOpacity(0.08),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Incentive Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Incentive Progress',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? AppTheme.darkTertiaryColor
                                    : AppTheme.tertiaryColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${(incentivePercent * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkTertiaryColor
                                  : AppTheme.tertiaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: incentivePercent,
                        minHeight: 10,
                        backgroundColor: isDark
                            ? AppTheme.darkOutlineVariantColor
                            : AppTheme.outlineVariantColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? AppTheme.darkTertiaryColor
                              : AppTheme.tertiaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹ ${m.incentiveEarned.toStringAsFixed(0)} earned',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.darkOnSurfaceVariantColor
                                : AppTheme.onSurfaceVariantColor,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Target: ₹ ${m.salesTarget.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.darkOnSurfaceVariantColor
                                : AppTheme.onSurfaceVariantColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Tasks
            Text(
              'Upcoming Tasks',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (recentTasks.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No tasks assigned',
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
              ...recentTasks.map((task) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getTaskTypeColor(task.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getTaskTypeIcon(task.type),
                          color: _getTaskTypeColor(task.type),
                          size: 22,
                        ),
                      ),
                      title: Text(
                        task.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTheme.darkOnSurfaceVariantColor
                              : AppTheme.onSurfaceVariantColor,
                        ),
                      ),
                      trailing: _buildStatusChip(task.status, isDark),
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
              ),
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
      case 'Completed':
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

  IconData _getTaskTypeIcon(String type) {
    switch (type) {
      case 'Complaint':
        return Icons.warning_amber_outlined;
      case 'AMC':
        return Icons.build_outlined;
      case 'Installation':
        return Icons.construction_outlined;
      default:
        return Icons.task_outlined;
    }
  }

  Color _getTaskTypeColor(String type) {
    switch (type) {
      case 'Complaint':
        return AppTheme.errorColor;
      case 'AMC':
        return AppTheme.secondaryColor;
      case 'Installation':
        return AppTheme.tertiaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
