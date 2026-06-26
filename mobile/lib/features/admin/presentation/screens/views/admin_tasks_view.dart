import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';
import '../admin_dashboard_screen.dart';

class AdminTasksView extends ConsumerStatefulWidget {
  const AdminTasksView({super.key});

  @override
  ConsumerState<AdminTasksView> createState() => _AdminTasksViewState();
}

class _AdminTasksViewState extends ConsumerState<AdminTasksView> {
  String _statusFilter = 'All';
  String _typeFilter = 'All Types';

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(adminTasksProvider);
    final customersState = ref.watch(adminCustomersProvider);
    final staffState = ref.watch(adminUsersProvider);
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    if (tasksState.isLoading || customersState.isLoading || staffState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(
          color: AppTheme.primaryColor,
          size: 50.0,
        ),
      );
    }

    if (tasksState.error != null) {
      return Center(
        child: Text('Error loading tasks: ${tasksState.error}'),
      );
    }

    // Filter tasks list
    final filteredTasks = tasksState.tasks.where((task) {
      final matchesStatus = _statusFilter == 'All' || task.status == _statusFilter;
      final matchesType = _typeFilter == 'All Types' || task.type == _typeFilter;

      final customer = customersState.customers.firstWhere(
        (c) => c.id == task.customerId,
        orElse: () => Customer(id: '', name: '', category: '', phone: '', address: '', amcStatus: '', nextAmcDate: '', products: []),
      );

      final staff = staffState.staffList.firstWhere(
        (s) => s.id == task.assignedTo,
        orElse: () => Staff(id: '', name: '', role: '', phone: '', lat: 0, lng: 0, assignedTasks: [], incentiveEarned: 0, salesTarget: 0, salaryDetails: SalaryDetails(base: 0, pf: 0, esi: 0, leavesTaken: 0)),
      );

      final matchesSearch = task.description.toLowerCase().contains(searchQuery) ||
          task.id.toLowerCase().contains(searchQuery) ||
          customer.name.toLowerCase().contains(searchQuery) ||
          staff.name.toLowerCase().contains(searchQuery);

      return matchesStatus && matchesType && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table info header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Service Tickets',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${filteredTasks.length} Tickets Found',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter Dropdowns
        _buildFiltersToolbar(),
        const SizedBox(height: 16),

        // Task Cards
        Expanded(
          child: filteredTasks.isEmpty
              ? const Center(child: Text('No service tasks found matching filters.'))
              : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];

                    final customer = customersState.customers.firstWhere(
                      (c) => c.id == task.customerId,
                      orElse: () => Customer(id: task.customerId, name: 'Unknown Customer', category: '', phone: '', address: '', amcStatus: '', nextAmcDate: '', products: []),
                    );

                    final staff = staffState.staffList.firstWhere(
                      (s) => s.id == task.assignedTo,
                      orElse: () => Staff(id: task.assignedTo, name: 'Unassigned', role: '', phone: '', lat: 0, lng: 0, assignedTasks: [], incentiveEarned: 0, salesTarget: 0, salaryDetails: SalaryDetails(base: 0, pf: 0, esi: 0, leavesTaken: 0)),
                    );

                    return _buildTaskCard(context, task, customer, staff);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFiltersToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Task Type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurfaceContainerColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppTheme.darkOutlineVariantColor : AppTheme.outlineVariantColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _typeFilter,
                dropdownColor: isDark ? AppTheme.darkSurfaceContainerColor : Colors.white,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceVariantColor,
                  fontSize: 13,
                ),
                icon: Icon(Icons.arrow_drop_down, color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _typeFilter = newValue);
                  }
                },
                items: <String>['All Types', 'Complaint', 'AMC', 'Installation']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Task Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurfaceContainerColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppTheme.darkOutlineVariantColor : AppTheme.outlineVariantColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                dropdownColor: isDark ? AppTheme.darkSurfaceContainerColor : Colors.white,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceVariantColor,
                  fontSize: 13,
                ),
                icon: Icon(Icons.arrow_drop_down, color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _statusFilter = newValue);
                  }
                },
                items: <String>['All', 'Open', 'Scheduled', 'Completed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'All' ? 'Status: All' : 'Status: $value',
                      style: TextStyle(color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, ServiceTask task, Customer customer, Staff staff) {
    final isComplaint = task.type == 'Complaint';
    final isInstallation = task.type == 'Installation';
    final isCompleted = task.status == 'Completed';

    Color typeColor = AppTheme.tertiaryColor;
    if (isComplaint) {
      typeColor = AppTheme.errorColor;
    } else if (isInstallation) {
      typeColor = AppTheme.primaryColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Task ID, Type, Status)
            Row(
              children: [
                Text(
                  task.id,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: typeColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    task.type,
                    style: TextStyle(color: typeColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle_outline : Icons.access_time,
                      color: isCompleted ? Colors.green : Colors.amber.shade700,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.status,
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.amber.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Task Description
            Text(
              task.description,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.onSurfaceColor),
            ),
            const SizedBox(height: 16),

            // Bottom Rows (Customer Name, Assigned Staff, Date)
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: AppTheme.outlineColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Client: ${customer.name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.handyman_outlined, size: 16, color: AppTheme.outlineColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Assignee: ${staff.name} (${staff.role})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 16, color: AppTheme.outlineColor),
                const SizedBox(width: 8),
                Text(
                  'Date Scheduled: ${task.date}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
