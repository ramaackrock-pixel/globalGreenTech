import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../admin_dashboard_screen.dart';

class AttendanceLog {
  final String date;
  final String staffName;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String status; // 'On Duty' or 'Completed'

  AttendanceLog({
    required this.date,
    required this.staffName,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.status,
  });
}

class AdminAttendanceView extends ConsumerWidget {
  const AdminAttendanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    // Mock logs representing the staff attendance records
    final List<AttendanceLog> mockLogs = [
      AttendanceLog(
        date: '24/06/2026',
        staffName: 'Rahul Kumar',
        checkIn: '09:00 AM',
        checkOut: '06:15 PM',
        duration: '9h 15m',
        status: 'Completed',
      ),
      AttendanceLog(
        date: '24/06/2026',
        staffName: 'Priya Sharma',
        checkIn: '09:30 AM',
        checkOut: 'Not checked out',
        duration: 'In Progress',
        status: 'On Duty',
      ),
      AttendanceLog(
        date: '23/06/2026',
        staffName: 'Rahul Kumar',
        checkIn: '08:45 AM',
        checkOut: '05:30 PM',
        duration: '8h 45m',
        status: 'Completed',
      ),
      AttendanceLog(
        date: '23/06/2026',
        staffName: 'Amit Patel',
        checkIn: '09:15 AM',
        checkOut: '06:00 PM',
        duration: '8h 45m',
        status: 'Completed',
      ),
      AttendanceLog(
        date: '22/06/2026',
        staffName: 'Priya Sharma',
        checkIn: '09:00 AM',
        checkOut: '05:45 PM',
        duration: '8h 45m',
        status: 'Completed',
      ),
    ];

    final filteredLogs = mockLogs.where((log) {
      return searchQuery.isEmpty || log.staffName.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header info card
        Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isDark ? theme.colorScheme.primary : AppTheme.primaryColor).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Logs',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Monitor field technician daily clock-ins and clock-outs.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Logs List
        Expanded(
          child: filteredLogs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 48,
                        color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No matching attendance logs found',
                        style: TextStyle(
                          color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    final isOnDuty = log.status == 'On Duty';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.staffName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isOnDuty ? Colors.amber : Colors.green).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: (isOnDuty ? Colors.amber : Colors.green).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isOnDuty ? Icons.timer_outlined : Icons.check_circle_outline,
                                        size: 14,
                                        color: isOnDuty ? Colors.amber.shade800 : Colors.green.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        log.status,
                                        style: TextStyle(
                                          color: isOnDuty ? Colors.amber.shade800 : Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
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
                                _buildDetailItem(theme, isDark, 'Date', log.date),
                                _buildDetailItem(theme, isDark, 'Shift Duration', log.duration),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailItem(theme, isDark, 'Check In', log.checkIn, valueColor: Colors.green.shade600),
                                _buildDetailItem(theme, isDark, 'Check Out', log.checkOut, valueColor: isOnDuty ? Colors.grey : null),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(ThemeData theme, bool isDark, String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor),
          ),
        ),
      ],
    );
  }
}
