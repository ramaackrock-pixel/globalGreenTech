import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/staff_controller.dart';

class StaffAttendanceView extends ConsumerWidget {
  const StaffAttendanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(staffAttendanceProvider);
    final dashState = ref.watch(staffDashboardProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (attendanceState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (attendanceState.error != null) {
      return Center(child: Text('Error: ${attendanceState.error}'));
    }

    final records = attendanceState.records;
    final isCheckedIn = dashState.metrics?.isCheckedIn ?? false;
    final checkInTime = dashState.metrics?.checkInTime ?? '--:--';

    // Calculate stats
    final presentDays = records.where((r) => r.status == 'Present').length;
    final leaveDays = records.where((r) => r.status == 'Leave').length;
    final halfDays = records.where((r) => r.status == 'Half Day').length;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(staffAttendanceProvider.notifier).fetchAttendance();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check-in / Check-out Card
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isCheckedIn
                                ? const Color(0xFF2E7D32)
                                : AppTheme.primaryColor)
                            .withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCheckedIn ? Icons.login : Icons.logout,
                        size: 40,
                        color: isCheckedIn
                            ? const Color(0xFF2E7D32)
                            : AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCheckedIn ? 'Checked In' : 'Not Checked In',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCheckedIn
                            ? const Color(0xFF2E7D32)
                            : AppTheme.errorColor,
                      ),
                    ),
                    if (isCheckedIn) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Since $checkInTime',
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.darkOnSurfaceVariantColor
                              : AppTheme.onSurfaceVariantColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isCheckedIn
                                  ? 'Checked out successfully!'
                                  : 'Checked in successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(
                          isCheckedIn ? Icons.logout : Icons.login,
                          size: 18,
                        ),
                        label: Text(
                          isCheckedIn ? 'Check Out' : 'Check In',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: isCheckedIn
                              ? AppTheme.errorColor
                              : const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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

            // Summary Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    label: 'Present',
                    value: presentDays.toString(),
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF2E7D32),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    label: 'Leave',
                    value: leaveDays.toString(),
                    icon: Icons.event_busy_outlined,
                    color: AppTheme.errorColor,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    label: 'Half Day',
                    value: halfDays.toString(),
                    icon: Icons.timelapse_outlined,
                    color: AppTheme.tertiaryColor,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Attendance History
            Text(
              'Recent History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppTheme.darkPrimaryColor
                              : AppTheme.primaryColor)
                          .withOpacity(0.06),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('Date',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Out',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Status',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                  // Table rows
                  ...records.map((record) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? AppTheme.darkOutlineVariantColor
                                    .withOpacity(0.3)
                                : AppTheme.outlineVariantColor
                                    .withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              record.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              record.checkIn,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              record.checkOut,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkOnSurfaceVariantColor
                                    : AppTheme.onSurfaceVariantColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildAttendanceChip(record.status),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isDark
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

  Widget _buildAttendanceChip(String status) {
    Color chipColor;
    switch (status) {
      case 'Present':
        chipColor = const Color(0xFF2E7D32);
        break;
      case 'Leave':
        chipColor = AppTheme.errorColor;
        break;
      case 'Half Day':
        chipColor = AppTheme.tertiaryColor;
        break;
      default:
        chipColor = AppTheme.outlineColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
