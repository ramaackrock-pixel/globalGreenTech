// Staff Dashboard Metrics
class StaffDashboardMetrics {
  final int todayTasks;
  final int completedTasks;
  final double incentiveEarned;
  final double salesTarget;
  final String checkInTime;
  final bool isCheckedIn;

  StaffDashboardMetrics({
    required this.todayTasks,
    required this.completedTasks,
    required this.incentiveEarned,
    required this.salesTarget,
    required this.checkInTime,
    required this.isCheckedIn,
  });

  factory StaffDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return StaffDashboardMetrics(
      todayTasks: (json['todayTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      incentiveEarned: (json['incentiveEarned'] as num?)?.toDouble() ?? 0.0,
      salesTarget: (json['salesTarget'] as num?)?.toDouble() ?? 0.0,
      checkInTime: json['checkInTime']?.toString() ?? '--:--',
      isCheckedIn: json['isCheckedIn'] as bool? ?? false,
    );
  }
}

// Staff Task (mirrors ServiceTask but from staff perspective)
class StaffTask {
  final String id;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String type; // Complaint, AMC, Installation
  final String status; // Open, Scheduled, In Progress, Completed
  final String date;
  final String description;
  final String priority; // High, Medium, Low

  StaffTask({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.type,
    required this.status,
    required this.date,
    required this.description,
    required this.priority,
  });

  factory StaffTask.fromJson(Map<String, dynamic> json) {
    return StaffTask(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      customerAddress: json['customerAddress']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'Medium',
    );
  }
}

// Attendance Record
class AttendanceRecord {
  final String date;
  final String checkIn;
  final String checkOut;
  final String hoursWorked;
  final String status; // Present, Absent, Half Day, Leave

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.hoursWorked,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: json['date']?.toString() ?? '',
      checkIn: json['checkIn']?.toString() ?? '--:--',
      checkOut: json['checkOut']?.toString() ?? '--:--',
      hoursWorked: json['hoursWorked']?.toString() ?? '0h',
      status: json['status']?.toString() ?? 'Absent',
    );
  }
}

// Staff Payslip
class StaffPayslip {
  final String month;
  final double baseSalary;
  final double pf;
  final double esi;
  final double incentive;
  final double deductions;
  final double netPay;
  final int leavesTaken;
  final int totalWorkingDays;

  StaffPayslip({
    required this.month,
    required this.baseSalary,
    required this.pf,
    required this.esi,
    required this.incentive,
    required this.deductions,
    required this.netPay,
    required this.leavesTaken,
    required this.totalWorkingDays,
  });

  factory StaffPayslip.fromJson(Map<String, dynamic> json) {
    return StaffPayslip(
      month: json['month']?.toString() ?? '',
      baseSalary: (json['baseSalary'] as num?)?.toDouble() ?? 0.0,
      pf: (json['pf'] as num?)?.toDouble() ?? 0.0,
      esi: (json['esi'] as num?)?.toDouble() ?? 0.0,
      incentive: (json['incentive'] as num?)?.toDouble() ?? 0.0,
      deductions: (json['deductions'] as num?)?.toDouble() ?? 0.0,
      netPay: (json['netPay'] as num?)?.toDouble() ?? 0.0,
      leavesTaken: (json['leavesTaken'] as num?)?.toInt() ?? 0,
      totalWorkingDays: (json['totalWorkingDays'] as num?)?.toInt() ?? 0,
    );
  }
}

class StaffIncentiveRecord {
  final String id;
  final String date;
  final String type;
  final double amount;
  final String description;

  StaffIncentiveRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });

  factory StaffIncentiveRecord.fromJson(Map<String, dynamic> json) {
    return StaffIncentiveRecord(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
    );
  }
}
