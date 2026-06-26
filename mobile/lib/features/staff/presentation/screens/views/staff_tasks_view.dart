import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/staff_controller.dart';
import '../../../data/models/staff_models.dart';

class StaffTasksView extends ConsumerStatefulWidget {
  const StaffTasksView({super.key});

  @override
  ConsumerState<StaffTasksView> createState() => _StaffTasksViewState();
}

class _StaffTasksViewState extends ConsumerState<StaffTasksView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _filters = ['All', 'Complaint', 'AMC', 'Installation'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(staffTasksProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (tasksState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (tasksState.error != null) {
      return Center(child: Text('Error: ${tasksState.error}'));
    }

    final selectedFilter = _filters[_tabController.index];
    final filteredTasks = selectedFilter == 'All'
        ? tasksState.tasks
        : tasksState.tasks.where((t) => t.type == selectedFilter).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(staffTasksProvider.notifier).fetchTasks();
      },
      child: Column(
        children: [
          // Filter tabs
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurfaceContainerLowestColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              unselectedLabelColor: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: _filters.map((f) => Tab(text: f)).toList(),
            ),
          ),

          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 56,
                          color: isDark
                              ? AppTheme.darkOutlineColor
                              : AppTheme.outlineColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No $selectedFilter tasks',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.darkOnSurfaceVariantColor
                                : AppTheme.onSurfaceVariantColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(context, task, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, StaffTask task, bool isDark) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: type badge + priority + status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(task.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getTypeIcon(task.type),
                          size: 14, color: _getTypeColor(task.type)),
                      const SizedBox(width: 4),
                      Text(
                        task.type,
                        style: TextStyle(
                          color: _getTypeColor(task.type),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (task.priority == 'High')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⚡ High',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                _buildStatusChip(task.status),
              ],
            ),
            const SizedBox(height: 14),

            // Customer name
            Text(
              task.customerName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Description
            Text(
              task.description,
              style: TextStyle(
                color: isDark
                    ? AppTheme.darkOnSurfaceVariantColor
                    : AppTheme.onSurfaceVariantColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Info row: address + date
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 15,
                    color: isDark
                        ? AppTheme.darkOutlineColor
                        : AppTheme.outlineColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    task.customerAddress,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.darkOutlineColor
                          : AppTheme.outlineColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_outlined,
                    size: 13,
                    color: isDark
                        ? AppTheme.darkOutlineColor
                        : AppTheme.outlineColor),
                const SizedBox(width: 4),
                Text(
                  task.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppTheme.darkOutlineColor
                        : AppTheme.outlineColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_outlined, size: 16),
                    label: const Text('Call', style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.navigation_outlined, size: 16),
                    label: const Text('Navigate', style: TextStyle(fontSize: 13)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
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

  IconData _getTypeIcon(String type) {
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

  Color _getTypeColor(String type) {
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
