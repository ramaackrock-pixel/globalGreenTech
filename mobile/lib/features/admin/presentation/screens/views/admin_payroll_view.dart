import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';
import '../admin_dashboard_screen.dart';

class AdminPayrollView extends ConsumerWidget {
  const AdminPayrollView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(adminUsersProvider);
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 800;

    if (usersState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (usersState.error != null) {
      return Center(child: Text('Error: ${usersState.error}'));
    }

    final staffList = usersState.staffList.where((s) {
      if (searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(searchQuery) ||
          s.role.toLowerCase().contains(searchQuery) ||
          s.id.toLowerCase().contains(searchQuery);
    }).toList();

    // Calculate totals
    double totalBaseSalary = 0;
    double totalIncentives = 0;
    double totalDeductions = 0;
    double totalNetPay = 0;
    for (final s in usersState.staffList) {
      final sal = s.salaryDetails;
      final net = sal.base + s.incentiveEarned - sal.pf - sal.esi;
      totalBaseSalary += sal.base;
      totalIncentives += s.incentiveEarned;
      totalDeductions += sal.pf + sal.esi;
      totalNetPay += net;
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(adminUsersProvider.notifier).fetchStaff();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payroll Summary Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 1.4 : 1.25,
              children: [
                _buildSummaryCard(
                  context: context,
                  title: 'Total Payroll',
                  value: '₹ ${_formatAmount(totalNetPay)}',
                  icon: Icons.account_balance_outlined,
                  color: AppTheme.primaryColor,
                  bgColor: (isDark
                          ? AppTheme.darkPrimaryColor
                          : AppTheme.primaryColor)
                      .withOpacity(0.08),
                ),
                _buildSummaryCard(
                  context: context,
                  title: 'Base Salary',
                  value: '₹ ${_formatAmount(totalBaseSalary)}',
                  icon: Icons.payments_outlined,
                  color: AppTheme.secondaryColor,
                  bgColor: (isDark
                          ? AppTheme.darkSecondaryColor
                          : AppTheme.secondaryColor)
                      .withOpacity(0.08),
                ),
                _buildSummaryCard(
                  context: context,
                  title: 'Incentives',
                  value: '₹ ${_formatAmount(totalIncentives)}',
                  icon: Icons.trending_up_outlined,
                  color: const Color(0xFF2E7D32),
                  bgColor: const Color(0xFF2E7D32).withOpacity(0.08),
                ),
                _buildSummaryCard(
                  context: context,
                  title: 'Deductions',
                  value: '₹ ${_formatAmount(totalDeductions)}',
                  icon: Icons.remove_circle_outline,
                  color: AppTheme.errorColor,
                  bgColor: AppTheme.errorColor.withOpacity(0.08),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Employees count + action
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  'Employee Payslips (${staffList.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payroll processing initiated'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_outlined, size: 16),
                  label: const Text('Process',
                      style: TextStyle(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Employee Payroll Cards
            if (staffList.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No employees found',
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
              ...staffList.map((staff) =>
                  _buildEmployeePayrollCard(context, staff, isDark, isTablet)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
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
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
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

  Widget _buildEmployeePayrollCard(
      BuildContext context, Staff staff, bool isDark, bool isTablet) {
    final sal = staff.salaryDetails;
    final netPay = sal.base + staff.incentiveEarned - sal.pf - sal.esi;
    final incentivePercent = staff.salesTarget > 0
        ? (staff.incentiveEarned / staff.salesTarget).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                      .withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.person_outline,
              color:
                  isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              size: 22,
            ),
          ),
          title: Text(
            staff.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${staff.role} • ID: ${staff.id}',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${netPay.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark
                      ? AppTheme.darkPrimaryColor
                      : AppTheme.primaryColor,
                ),
              ),
              Text(
                'Net Pay',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppTheme.darkOnSurfaceVariantColor
                      : AppTheme.onSurfaceVariantColor,
                ),
              ),
            ],
          ),
          children: [
            const Divider(),
            const SizedBox(height: 4),

            // Salary Breakdown
            _buildPayRow('Base Salary', '₹ ${sal.base.toStringAsFixed(0)}',
                isDark,
                isPositive: true),
            _buildPayRow(
                'Incentive Earned',
                '+ ₹ ${staff.incentiveEarned.toStringAsFixed(0)}',
                isDark,
                isPositive: true),
            _buildPayRow(
                'PF Deduction', '- ₹ ${sal.pf.toStringAsFixed(0)}', isDark,
                isPositive: false),
            _buildPayRow(
                'ESI Deduction', '- ₹ ${sal.esi.toStringAsFixed(0)}', isDark,
                isPositive: false),
            const Divider(height: 20),
            _buildPayRow(
              'Net Payable',
              '₹ ${netPay.toStringAsFixed(0)}',
              isDark,
              isBold: true,
            ),

            const SizedBox(height: 16),

            // Incentive Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Incentive Target',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppTheme.darkOnSurfaceVariantColor
                        : AppTheme.onSurfaceVariantColor,
                  ),
                ),
                Text(
                  '${(incentivePercent * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTheme.darkTertiaryColor
                        : AppTheme.tertiaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: incentivePercent,
                minHeight: 8,
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
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ ${staff.incentiveEarned.toStringAsFixed(0)} earned',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppTheme.darkOutlineColor
                        : AppTheme.outlineColor,
                  ),
                ),
                Text(
                  'Target: ₹ ${staff.salesTarget.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppTheme.darkOutlineColor
                        : AppTheme.outlineColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Additional Info
            Row(
              children: [
                _buildInfoChip(
                  Icons.event_busy_outlined,
                  '${sal.leavesTaken} Leaves',
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.assignment_outlined,
                  '${staff.assignedTasks.length} Tasks',
                  isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPayRow(String label, String value, bool isDark,
      {bool? isPositive, bool isBold = false}) {
    Color? valueColor;
    if (isPositive == true) {
      valueColor = const Color(0xFF2E7D32);
    } else if (isPositive == false) {
      valueColor = AppTheme.errorColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isBold ? 15 : 13,
              color: isBold
                  ? (isDark
                      ? AppTheme.darkPrimaryColor
                      : AppTheme.primaryColor)
                  : valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (isDark
                ? AppTheme.darkOnSurfaceVariantColor
                : AppTheme.onSurfaceVariantColor)
            .withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
