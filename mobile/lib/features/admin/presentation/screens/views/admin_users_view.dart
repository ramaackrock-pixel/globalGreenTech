import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';
import '../admin_dashboard_screen.dart';

class AdminUsersView extends ConsumerWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffState = ref.watch(adminUsersProvider);
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    if (staffState.isLoading) {
      return const Center(
        child: AdaptiveProgressIndicator(radius: 20),
      );
    }

    if (staffState.error != null) {
      return Center(
        child: Text('Error loading staff accounts: ${staffState.error}'),
      );
    }

    // Filter staff list based on search query
    final filteredStaff = staffState.staffList.where((staff) {
      return staff.name.toLowerCase().contains(searchQuery) ||
          staff.role.toLowerCase().contains(searchQuery) ||
          staff.id.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table Header summary
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
              Expanded(
                child: Text(
                  'Staff Members Directory',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${filteredStaff.length} Accounts Found',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Staff expandable list
        Expanded(
          child: filteredStaff.isEmpty
              ? const Center(child: Text('No staff members found matching search query.'))
              : ListView.builder(
                  itemCount: filteredStaff.length,
                  itemBuilder: (context, index) {
                    final staff = filteredStaff[index];
                    return _buildStaffItem(context, staff);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStaffItem(BuildContext context, Staff staff) {
    final theme = Theme.of(context);
    final targetCompletion = staff.salesTarget > 0 ? (staff.incentiveEarned / staff.salesTarget) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        shape: const Border(), // Remove default dividers
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
          child: Text(
            staff.name.isNotEmpty ? staff.name.substring(0, 1).toUpperCase() : 'S',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          staff.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  staff.role,
                  style: theme.textTheme.labelMedium?.copyWith(fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ID: ${staff.id}',
                style: theme.textTheme.labelMedium?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Details Grid (Phone, Targets, Tasks)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailColumn(context, 'Contact Phone', staff.phone, Icons.phone_outlined),
              ),
              Expanded(
                child: _buildDetailColumn(
                  context,
                  'Assigned Tasks',
                  '${staff.assignedTasks.length} Service Tickets',
                  Icons.assignment_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDetailColumn(
                  context,
                  'Incentives Earned',
                  '₹ ${staff.incentiveEarned.toInt()}',
                  Icons.currency_rupee,
                ),
              ),
              Expanded(
                child: _buildDetailColumn(
                  context,
                  'Sales Target',
                  '₹ ${staff.salesTarget.toInt()}',
                  Icons.track_changes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Target Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Target Achievements', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(
                    '${(targetCompletion * 100).toInt()}% Met',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: targetCompletion.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payroll details section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.payment_outlined, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Payroll Details (Monthly)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPayrollRow(context, 'Base Salary', '₹ ${staff.salaryDetails.base.toInt()}'),
                _buildPayrollRow(context, 'Provident Fund (PF)', '- ₹ ${staff.salaryDetails.pf.toInt()}'),
                _buildPayrollRow(context, 'ESI contribution', '- ₹ ${staff.salaryDetails.esi.toInt()}'),
                _buildPayrollRow(context, 'Leaves Taken', '${staff.salaryDetails.leavesTaken} days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayrollRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
