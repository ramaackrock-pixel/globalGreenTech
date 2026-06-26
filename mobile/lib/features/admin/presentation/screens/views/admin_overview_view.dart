import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';

class AdminOverviewView extends ConsumerWidget {
  const AdminOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(adminMetricsProvider);
    final tasksState = ref.watch(adminTasksProvider);
    final inventoryState = ref.watch(adminInventoryProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;

    // Pull datasets or load
    if (metricsState.isLoading ||
        tasksState.isLoading ||
        inventoryState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (metricsState.error != null) {
      return Center(
        child: Text('Error loading dashboard: ${metricsState.error}'),
      );
    }

    final m = metricsState.metrics;
    if (m == null) return const SizedBox();

    // Prepare lists
    final recentTasks = tasksState.tasks.take(5).toList();
    final lowStockItems = inventoryState.items
        .where((item) => item.isLowStock)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(adminMetricsProvider.notifier).fetchMetrics();
        ref.read(adminTasksProvider.notifier).fetchTasks();
        ref.read(adminInventoryProvider.notifier).fetchInventory();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Grid
            if (isTablet)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.25,
                children: [
                  _buildKpiCard(
                    context: context,
                    title: 'Total Customers',
                    value: m.totalCustomers.toString(),
                    icon: Icons.people_outline,
                    color: AppTheme.secondaryColor,
                    bgColor: AppTheme.secondaryColor.withOpacity(0.08),
                  ),
                  _buildKpiCard(
                    context: context,
                    title: 'Open Complaints',
                    value: m.openComplaints.toString(),
                    icon: Icons.chat_bubble_outline,
                    color: AppTheme.tertiaryColor,
                    bgColor: AppTheme.tertiaryColor.withOpacity(0.08),
                  ),
                  _buildKpiCard(
                    context: context,
                    title: 'Low Stock Alerts',
                    value: m.lowStockAlerts.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: AppTheme.errorColor,
                    bgColor: AppTheme.errorColor.withOpacity(0.08),
                  ),
                  _buildKpiCard(
                    context: context,
                    title: "Today's Revenue",
                    value: m.todayRevenue,
                    icon: Icons.currency_rupee,
                    color: AppTheme.primaryColor,
                    bgColor: AppTheme.primaryColor.withOpacity(0.08),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: _buildKpiCard(
                            context: context,
                            title: 'Total Customers',
                            value: m.totalCustomers.toString(),
                            icon: Icons.people_outline,
                            color: AppTheme.secondaryColor,
                            bgColor: AppTheme.secondaryColor.withOpacity(0.08),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: _buildKpiCard(
                            context: context,
                            title: 'Open Complaints',
                            value: m.openComplaints.toString(),
                            icon: Icons.chat_bubble_outline,
                            color: AppTheme.tertiaryColor,
                            bgColor: AppTheme.tertiaryColor.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: _buildKpiCard(
                            context: context,
                            title: 'Low Stock Alerts',
                            value: m.lowStockAlerts.toString(),
                            icon: Icons.warning_amber_rounded,
                            color: AppTheme.errorColor,
                            bgColor: AppTheme.errorColor.withOpacity(0.08),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: _buildKpiCard(
                            context: context,
                            title: "Today's Revenue",
                            value: m.todayRevenue,
                            icon: Icons.currency_rupee,
                            color: AppTheme.primaryColor,
                            bgColor: AppTheme.primaryColor.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Tables Layout
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRecentTasksSection(context, recentTasks),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: _buildInventoryAlertsSection(context, lowStockItems),
                  ),
                ],
              )
            else ...[
              _buildRecentTasksSection(context, recentTasks),
              const SizedBox(height: 24),
              _buildInventoryAlertsSection(context, lowStockItems),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // KPI Card builder
  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative background glow matching the card's accent color
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.04),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon and Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Modern Glassy Icon Badge
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      // Small decorative indicator
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark 
                          ? AppTheme.darkOnSurfaceColor.withOpacity(0.5) 
                          : AppTheme.onSurfaceVariantColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Value
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent Service Tasks Card Table
  Widget _buildRecentTasksSection(
    BuildContext context,
    List<ServiceTask> tasks,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Service Tasks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
          ),
          const Divider(height: 1),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('No service tasks logged yet.')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isComplaint = task.type == 'Complaint';
                final isCompleted = task.status == 'Completed';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Row(
                    children: [
                      Text(
                        task.id,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isComplaint
                              ? AppTheme.errorColor.withOpacity(0.08)
                              : AppTheme.tertiaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isComplaint
                                ? AppTheme.errorColor.withOpacity(0.2)
                                : AppTheme.tertiaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          task.type,
                          style: TextStyle(
                            color: isComplaint
                                ? AppTheme.errorColor
                                : AppTheme.tertiaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.schedule,
                        color: isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Inventory Alerts Card List
  Widget _buildInventoryAlertsSection(
    BuildContext context,
    List<InventoryItem> items,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory Alerts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${items.length} Items',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('All items are adequately stocked.')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'SKU: ${item.sku}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.errorColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.stock.toString(),
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'LEFT',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariantColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
