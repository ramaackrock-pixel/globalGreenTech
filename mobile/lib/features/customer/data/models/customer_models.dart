import 'package:flutter/material.dart';

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

// Marketplace product categories
enum MarketCategory { all, purifiers, filters, services }

// Product class representing RO products/services
class MarketProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final double mrp;
  final double rating;
  final int reviewsCount;
  final MarketCategory category;
  final String badge;
  final IconData icon;
  final String? imagePath;
  final Map<String, String> specifications;

  const MarketProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.badge,
    required this.icon,
    this.imagePath,
    required this.specifications,
  });

  double get discountPercentage => mrp > price ? ((mrp - price) / mrp * 100) : 0.0;

  factory MarketProduct.fromJson(Map<String, dynamic> json) {
    return MarketProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      category: _parseCategory(json['category']?.toString()),
      badge: json['badge']?.toString() ?? '',
      icon: _parseIcon(json['icon']?.toString()),
      imagePath: json['imagePath']?.toString(),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'mrp': mrp,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'category': category.name,
      'badge': badge,
      'icon': _getIconString(icon),
      'imagePath': imagePath,
      'specifications': specifications,
    };
  }

  static MarketCategory _parseCategory(String? categoryStr) {
    switch (categoryStr) {
      case 'purifiers':
        return MarketCategory.purifiers;
      case 'filters':
        return MarketCategory.filters;
      case 'services':
        return MarketCategory.services;
      default:
        return MarketCategory.all;
    }
  }

  static IconData _parseIcon(String? iconStr) {
    switch (iconStr) {
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'kitchen':
        return Icons.kitchen_outlined;
      case 'solar_power':
        return Icons.solar_power_outlined;
      case 'layers':
        return Icons.layers_outlined;
      case 'blur_linear':
        return Icons.blur_linear;
      case 'grain':
        return Icons.grain_outlined;
      case 'verified_user':
        return Icons.verified_user_outlined;
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  static String _getIconString(IconData icon) {
    if (icon == Icons.water_drop_outlined) return 'water_drop';
    if (icon == Icons.kitchen_outlined) return 'kitchen';
    if (icon == Icons.solar_power_outlined) return 'solar_power';
    if (icon == Icons.layers_outlined) return 'layers';
    if (icon == Icons.blur_linear) return 'blur_linear';
    if (icon == Icons.grain_outlined) return 'grain';
    if (icon == Icons.verified_user_outlined) return 'verified_user';
    if (icon == Icons.cleaning_services_outlined) return 'cleaning_services';
    return 'shopping_bag';
  }
}
