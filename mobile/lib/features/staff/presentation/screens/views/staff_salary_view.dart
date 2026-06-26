import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/staff_controller.dart';
import '../../../data/models/staff_models.dart';

class StaffSalaryView extends ConsumerWidget {
  const StaffSalaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payslipState = ref.watch(staffPayslipProvider);
    final dashState = ref.watch(staffDashboardProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (payslipState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (payslipState.error != null) {
      return Center(child: Text('Error: ${payslipState.error}'));
    }

    final payslips = payslipState.payslips;
    if (payslips.isEmpty) {
      return const Center(child: Text('No payslip data available'));
    }

    final current = payslips.first;
    final incentivePercent = dashState.metrics != null &&
            dashState.metrics!.salesTarget > 0
        ? (dashState.metrics!.incentiveEarned / dashState.metrics!.salesTarget)
            .clamp(0.0, 1.0)
        : 0.0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(staffPayslipProvider.notifier).fetchPayslips();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Month Payslip
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          current.month,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? AppTheme.darkPrimaryColor
                                    : AppTheme.primaryColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Current',
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
                    const SizedBox(height: 20),

                    // Net Pay highlight
                    Container(
                      width: double.infinity,
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Net Pay',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹ ${current.netPay.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Breakdown
                    _buildPayRow('Base Salary', '₹ ${current.baseSalary.toStringAsFixed(0)}',
                        isDark, isPositive: true),
                    _buildPayRow('Incentive', '+ ₹ ${current.incentive.toStringAsFixed(0)}',
                        isDark, isPositive: true),
                    const Divider(height: 24),
                    _buildPayRow('PF Contribution', '- ₹ ${current.pf.toStringAsFixed(0)}',
                        isDark, isPositive: false),
                    _buildPayRow('ESI', '- ₹ ${current.esi.toStringAsFixed(0)}',
                        isDark, isPositive: false),
                    const Divider(height: 24),
                    _buildPayRow(
                      'Working Days',
                      '${current.totalWorkingDays} days',
                      isDark,
                    ),
                    _buildPayRow(
                      'Leaves Taken',
                      '${current.leavesTaken} days',
                      isDark,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Incentive Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Incentive Target',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                    Text(
                      '${(incentivePercent * 100).toStringAsFixed(0)}% of target achieved',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.darkOnSurfaceVariantColor
                            : AppTheme.onSurfaceVariantColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Payslip History
            Text(
              'Payslip History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...payslips.skip(1).map((slip) => _buildHistoryCard(context, slip, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildPayRow(String label, String value, bool isDark,
      {bool? isPositive}) {
    Color? valueColor;
    if (isPositive == true) {
      valueColor = const Color(0xFF2E7D32);
    } else if (isPositive == false) {
      valueColor = AppTheme.errorColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppTheme.darkOnSurfaceVariantColor
                  : AppTheme.onSurfaceVariantColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
      BuildContext context, StaffPayslip slip, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                .withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          slip.month,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${slip.totalWorkingDays} working days • ${slip.leavesTaken} leaves',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppTheme.darkOnSurfaceVariantColor
                : AppTheme.onSurfaceVariantColor,
          ),
        ),
        trailing: Text(
          '₹ ${slip.netPay.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
