// Customer Dashboard Metrics
class CustomerDashboardMetrics {
  final int installedSystems;
  final String amcStatus;
  final String nextServiceDate;
  final double referralBonus;
  final int openComplaints;
  final String warrantyStatus;

  CustomerDashboardMetrics({
    required this.installedSystems,
    required this.amcStatus,
    required this.nextServiceDate,
    required this.referralBonus,
    required this.openComplaints,
    required this.warrantyStatus,
  });

  factory CustomerDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return CustomerDashboardMetrics(
      installedSystems: (json['installedSystems'] as num?)?.toInt() ?? 0,
      amcStatus: json['amcStatus']?.toString() ?? 'Inactive',
      nextServiceDate: json['nextServiceDate']?.toString() ?? '--',
      referralBonus: (json['referralBonus'] as num?)?.toDouble() ?? 0.0,
      openComplaints: (json['openComplaints'] as num?)?.toInt() ?? 0,
      warrantyStatus: json['warrantyStatus']?.toString() ?? 'Unknown',
    );
  }
}

// Customer Product (installed system)
class CustomerProduct {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final String installDate;
  final String warrantyStart;
  final String warrantyEnd;
  final String status; // Active, Warranty Expired
  final List<String> coveredItems;

  CustomerProduct({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.installDate,
    required this.warrantyStart,
    required this.warrantyEnd,
    required this.status,
    required this.coveredItems,
  });

  factory CustomerProduct.fromJson(Map<String, dynamic> json) {
    return CustomerProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? '',
      installDate: json['installDate']?.toString() ?? '',
      warrantyStart: json['warrantyStart']?.toString() ?? '',
      warrantyEnd: json['warrantyEnd']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
      coveredItems: List<String>.from(json['coveredItems'] ?? []),
    );
  }
}

// Customer Service Request
class CustomerServiceRequest {
  final String id;
  final String type; // Complaint, AMC Visit, Installation
  final String status; // Open, Scheduled, In Progress, Resolved
  final String date;
  final String description;
  final String assignedTechnician;
  final String productName;

  CustomerServiceRequest({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.description,
    required this.assignedTechnician,
    required this.productName,
  });

  factory CustomerServiceRequest.fromJson(Map<String, dynamic> json) {
    return CustomerServiceRequest(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      assignedTechnician: json['assignedTechnician']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
    );
  }
}

// Customer Invoice / Billing Record
class CustomerInvoice {
  final String id;
  final String type; // AMC Renewal, Service Charge, Installation
  final String date;
  final double amount;
  final String status; // Paid, Pending, Overdue
  final String description;

  CustomerInvoice({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
    required this.status,
    required this.description,
  });

  factory CustomerInvoice.fromJson(Map<String, dynamic> json) {
    return CustomerInvoice(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
