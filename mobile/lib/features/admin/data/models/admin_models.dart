// Customer Product Model
class CustomerProduct {
  final String id;
  final String name;
  final String warrantyStart;
  final String warrantyEnd;
  final List<String> coveredItems;

  CustomerProduct({
    required this.id,
    required this.name,
    required this.warrantyStart,
    required this.warrantyEnd,
    required this.coveredItems,
  });

  factory CustomerProduct.fromJson(Map<String, dynamic> json) {
    return CustomerProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      warrantyStart: json['warrantyStart']?.toString() ?? '',
      warrantyEnd: json['warrantyEnd']?.toString() ?? '',
      coveredItems: List<String>.from(json['coveredItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'warrantyStart': warrantyStart,
        'warrantyEnd': warrantyEnd,
        'coveredItems': coveredItems,
      };
}

// Customer Model
class Customer {
  final String id;
  final String name;
  final String category;
  final String phone;
  final String address;
  final String amcStatus;
  final String nextAmcDate;
  final List<CustomerProduct> products;

  Customer({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.address,
    required this.amcStatus,
    required this.nextAmcDate,
    required this.products,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      amcStatus: json['amcStatus']?.toString() ?? '',
      nextAmcDate: json['nextAmcDate']?.toString() ?? '',
      products: (json['products'] as List?)
              ?.map((e) => CustomerProduct.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'phone': phone,
        'address': address,
        'amcStatus': amcStatus,
        'nextAmcDate': nextAmcDate,
        'products': products.map((e) => e.toJson()).toList(),
      };
}

// Inventory Item Model
class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int stock;
  final int minStockAlert;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
    required this.minStockAlert,
  });

  bool get isLowStock => stock <= minStockAlert;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      minStockAlert: (json['minStockAlert'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'price': price,
        'stock': stock,
        'minStockAlert': minStockAlert,
      };
}

// Service Task Model
class ServiceTask {
  final String id;
  final String customerId;
  final String type; // e.g. Complaint, AMC, Installation
  final String status; // e.g. Open, Scheduled, Completed
  final String assignedTo; // staff ID
  final String date;
  final String description;

  ServiceTask({
    required this.id,
    required this.customerId,
    required this.type,
    required this.status,
    required this.assignedTo,
    required this.date,
    required this.description,
  });

  factory ServiceTask.fromJson(Map<String, dynamic> json) {
    return ServiceTask(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      assignedTo: json['assignedTo']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'type': type,
        'status': status,
        'assignedTo': assignedTo,
        'date': date,
        'description': description,
      };
}

// Salary Details Model
class SalaryDetails {
  final double base;
  final double pf;
  final double esi;
  final int leavesTaken;

  SalaryDetails({
    required this.base,
    required this.pf,
    required this.esi,
    required this.leavesTaken,
  });

  factory SalaryDetails.fromJson(Map<String, dynamic> json) {
    return SalaryDetails(
      base: (json['base'] as num?)?.toDouble() ?? 0.0,
      pf: (json['pf'] as num?)?.toDouble() ?? 0.0,
      esi: (json['esi'] as num?)?.toDouble() ?? 0.0,
      leavesTaken: (json['leavesTaken'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'base': base,
        'pf': pf,
        'esi': esi,
        'leavesTaken': leavesTaken,
      };
}

// Staff Model
class Staff {
  final String id;
  final String name;
  final String role;
  final String phone;
  final double lat;
  final double lng;
  final List<String> assignedTasks;
  final double incentiveEarned;
  final double salesTarget;
  final SalaryDetails salaryDetails;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.assignedTasks,
    required this.incentiveEarned,
    required this.salesTarget,
    required this.salaryDetails,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    final loc = json['currentLocation'] as Map<String, dynamic>? ?? {};
    return Staff(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      lat: (loc['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (loc['lng'] as num?)?.toDouble() ?? 0.0,
      assignedTasks: List<String>.from(json['assignedTasks'] ?? []),
      incentiveEarned: (json['incentiveEarned'] as num?)?.toDouble() ?? 0.0,
      salesTarget: (json['salesTarget'] as num?)?.toDouble() ?? 0.0,
      salaryDetails: SalaryDetails.fromJson(json['salaryDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'phone': phone,
        'currentLocation': {'lat': lat, 'lng': lng},
        'assignedTasks': assignedTasks,
        'incentiveEarned': incentiveEarned,
        'salesTarget': salesTarget,
        'salaryDetails': salaryDetails.toJson(),
      };
}

// Dashboard Metrics Model
class DashboardMetrics {
  final int totalCustomers;
  final int openComplaints;
  final int lowStockAlerts;
  final String todayRevenue;

  DashboardMetrics({
    required this.totalCustomers,
    required this.openComplaints,
    required this.lowStockAlerts,
    required this.todayRevenue,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
      openComplaints: (json['openComplaints'] as num?)?.toInt() ?? 0,
      lowStockAlerts: (json['lowStockAlerts'] as num?)?.toInt() ?? 0,
      todayRevenue: json['todayRevenue']?.toString() ?? '₹ 0',
    );
  }
}
