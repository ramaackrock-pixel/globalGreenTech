import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulate network latency of 600ms
    await Future.delayed(const Duration(milliseconds: 600));

    final path = options.path;
    final cleanPath = path.replaceFirst(ApiEndpoints.baseUrl, '');

    // Single Login Flow
    if (cleanPath == ApiEndpoints.login) {
      final data = options.data;
      String? email;
      String? password;

      if (data is Map<String, dynamic>) {
        email = data['email']?.toString();
        password = data['password']?.toString();
      } else if (data is String) {
        try {
          final parsed = jsonDecode(data);
          email = parsed['email']?.toString();
          password = parsed['password']?.toString();
        } catch (_) {}
      }

      if (email == 'admin@gmail.com' && password == 'admin123') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock-admin-token-xyz123',
              'role': 'admin',
              'id': 'a1',
              'name': 'Admin User',
              'email': 'admin@gmail.com',
            },
          ),
        );
        return;
      } else if (email == 'staff@gmail.com' && password == 'staff123') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock-staff-token-xyz123',
              'role': 'staff',
              'id': 's1',
              'name': 'Jane Smith',
              'email': 'staff@gmail.com',
            },
          ),
        );
        return;
      } else if (email == 'customer@gmail.com' && password == 'customer123') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock-customer-token-xyz123',
              'role': 'customer',
              'id': 'c1',
              'name': 'Acme Corp',
              'email': 'customer@gmail.com',
            },
          ),
        );
        return;
      } else {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'message': 'Invalid email or password.'},
            ),
          ),
        );
        return;
      }
    }

    // Forgot Password
    if (cleanPath == ApiEndpoints.forgotPassword) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'message': 'Password reset link sent to your email.'},
        ),
      );
      return;
    }

    // Admin Dashboard Metrics
    if (cleanPath == ApiEndpoints.adminDashboardMetrics) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'totalCustomers': 2,
            'openComplaints': 1,
            'lowStockAlerts': 3,
            'todayRevenue': '₹ 15,400',
          },
        ),
      );
      return;
    }

    // Admin Customers & AMC
    if (cleanPath == ApiEndpoints.adminCustomers) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockCustomers,
        ),
      );
      return;
    }

    // Admin Tasks (Service tickets)
    if (cleanPath == ApiEndpoints.adminTasks) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockTasks,
        ),
      );
      return;
    }

    // Admin Inventory
    if (cleanPath == ApiEndpoints.adminInventory) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockInventory,
        ),
      );
      return;
    }

    // Admin Users (Staff list)
    if (cleanPath == ApiEndpoints.adminUsers) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockStaff,
        ),
      );
      return;
    }

    // Staff Dashboard Metrics
    if (cleanPath == ApiEndpoints.staffDashboard) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'todayTasks': 4,
            'completedTasks': 2,
            'incentiveEarned': 2500.0,
            'salesTarget': 10000.0,
            'checkInTime': '09:15 AM',
            'isCheckedIn': true,
          },
        ),
      );
      return;
    }

    // Staff Tasks
    if (cleanPath == ApiEndpoints.staffTasks) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockStaffTasks,
        ),
      );
      return;
    }

    // Staff Attendance
    if (cleanPath == ApiEndpoints.staffAttendance) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockStaffAttendance,
        ),
      );
      return;
    }

    // Staff Payslip
    if (cleanPath == ApiEndpoints.staffPayslip) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockStaffPayslips,
        ),
      );
      return;
    }

    // Staff Inventory
    if (cleanPath == ApiEndpoints.staffInventory) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockInventory,
        ),
      );
      return;
    }

    // Staff Incentives
    if (cleanPath == ApiEndpoints.staffIncentives) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockStaffIncentives,
        ),
      );
      return;
    }

    // Customer Dashboard Metrics
    if (cleanPath == ApiEndpoints.customerDashboard) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'installedSystems': 2,
            'amcStatus': 'Active (Expires 2027-01-10)',
            'nextServiceDate': '2026-06-25',
            'referralBonus': 500.0,
            'openComplaints': 1,
            'warrantyStatus': 'Under Warranty',
          },
        ),
      );
      return;
    }

    // Customer Products
    if (cleanPath == ApiEndpoints.customerProducts) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockCustomerProducts,
        ),
      );
      return;
    }

    // Customer Service Requests
    if (cleanPath == ApiEndpoints.customerServiceRequests) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockCustomerServiceRequests,
        ),
      );
      return;
    }

    // Customer Invoices
    if (cleanPath == ApiEndpoints.customerInvoices) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _mockCustomerInvoices,
        ),
      );
      return;
    }

    // Pass through for other URLs
    super.onRequest(options, handler);
  }

  // Raw mock datasets extracted from the React app mockData JSON files
  final List<Map<String, dynamic>> _mockCustomers = [
    {
      "id": "c1",
      "name": "Acme Corp",
      "category": "Commercial",
      "phone": "+1234567890",
      "address": "123 Business Rd, Tech Park",
      "amcStatus": "Active",
      "nextAmcDate": "2026-07-15",
      "products": [
        {
          "id": "p1",
          "name": "Commercial RO 500LPH",
          "warrantyStart": "2025-01-10",
          "warrantyEnd": "2027-01-10",
          "coveredItems": ["Pump", "Membrane", "Panel"]
        }
      ]
    },
    {
      "id": "c2",
      "name": "John Doe",
      "category": "Residential",
      "phone": "+0987654321",
      "address": "456 Home Ave, Suburbia",
      "amcStatus": "Due Soon",
      "nextAmcDate": "2026-06-20",
      "products": [
        {
          "id": "p2",
          "name": "Under-sink RO 15LPH",
          "warrantyStart": "2024-05-20",
          "warrantyEnd": "2025-05-20",
          "coveredItems": ["Filters", "Adapter"]
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _mockInventory = [
    {
      "id": "i1",
      "name": "Spun Filter",
      "sku": "SF-001",
      "price": 150,
      "stock": 120,
      "minStockAlert": 50
    },
    {
      "id": "i2",
      "name": "Carbon Filter",
      "sku": "CF-002",
      "price": 250,
      "stock": 45,
      "minStockAlert": 50
    },
    {
      "id": "i3",
      "name": "RO Membrane 75 GPD",
      "sku": "RM-075",
      "price": 1200,
      "stock": 12,
      "minStockAlert": 15
    },
    {
      "id": "i4",
      "name": "Booster Pump",
      "sku": "BP-100",
      "price": 2200,
      "stock": 8,
      "minStockAlert": 10
    }
  ];

  final List<Map<String, dynamic>> _mockTasks = [
    {
      "id": "t1",
      "customerId": "c1",
      "type": "Complaint",
      "status": "Open",
      "assignedTo": "s1",
      "date": "2026-06-17",
      "description": "Low water pressure from main commercial line."
    },
    {
      "id": "t2",
      "customerId": "c2",
      "type": "AMC",
      "status": "Scheduled",
      "assignedTo": "s1",
      "date": "2026-06-18",
      "description": "Quarterly AMC visit. Replace spun filter."
    },
    {
      "id": "t3",
      "customerId": "c1",
      "type": "Installation",
      "status": "Completed",
      "assignedTo": "s2",
      "date": "2026-06-15",
      "description": "New 500LPH unit installation."
    }
  ];

  final List<Map<String, dynamic>> _mockStaff = [
    {
      "id": "s1",
      "name": "Jane Smith",
      "role": "Technician",
      "phone": "+1122334455",
      "currentLocation": {"lat": 12.9716, "lng": 77.5946},
      "assignedTasks": ["t1", "t2"],
      "incentiveEarned": 2500,
      "salesTarget": 10000,
      "salaryDetails": {
        "base": 30000,
        "pf": 1800,
        "esi": 250,
        "leavesTaken": 2
      }
    },
    {
      "id": "s2",
      "name": "Mike Johnson",
      "role": "Senior Technician",
      "phone": "+5544332211",
      "currentLocation": {"lat": 12.9352, "lng": 77.6245},
      "assignedTasks": ["t3"],
      "incentiveEarned": 4200,
      "salesTarget": 15000,
      "salaryDetails": {
        "base": 45000,
        "pf": 2200,
        "esi": 350,
        "leavesTaken": 0
      }
    }
  ];

  final List<Map<String, dynamic>> _mockStaffTasks = [
    {
      "id": "st1",
      "customerName": "Acme Corp",
      "customerAddress": "123 Business Rd, Tech Park",
      "customerPhone": "+1234567890",
      "type": "Complaint",
      "status": "Open",
      "date": "2026-06-19",
      "description": "Low water pressure from main commercial RO line. Customer reports intermittent flow.",
      "priority": "High"
    },
    {
      "id": "st2",
      "customerName": "John Doe",
      "customerAddress": "456 Home Ave, Suburbia",
      "customerPhone": "+0987654321",
      "type": "AMC",
      "status": "Scheduled",
      "date": "2026-06-19",
      "description": "Quarterly AMC visit. Replace spun filter and check membrane pressure.",
      "priority": "Medium"
    },
    {
      "id": "st3",
      "customerName": "Metro Hospital",
      "customerAddress": "789 Health Blvd, City Center",
      "customerPhone": "+1122334455",
      "type": "Installation",
      "status": "In Progress",
      "date": "2026-06-18",
      "description": "New 1000LPH commercial RO unit installation for hospital wing B.",
      "priority": "High"
    },
    {
      "id": "st4",
      "customerName": "Sunrise Apartments",
      "customerAddress": "321 Sunrise Ln, East Side",
      "customerPhone": "+6677889900",
      "type": "AMC",
      "status": "Completed",
      "date": "2026-06-17",
      "description": "Annual maintenance visit. All filters replaced, TDS verified at 45ppm.",
      "priority": "Low"
    },
  ];

  final List<Map<String, dynamic>> _mockStaffAttendance = [
    {
      "date": "2026-06-19",
      "checkIn": "09:15 AM",
      "checkOut": "--:--",
      "hoursWorked": "6h 45m",
      "status": "Present"
    },
    {
      "date": "2026-06-18",
      "checkIn": "09:00 AM",
      "checkOut": "06:30 PM",
      "hoursWorked": "9h 30m",
      "status": "Present"
    },
    {
      "date": "2026-06-17",
      "checkIn": "09:10 AM",
      "checkOut": "06:00 PM",
      "hoursWorked": "8h 50m",
      "status": "Present"
    },
    {
      "date": "2026-06-16",
      "checkIn": "--:--",
      "checkOut": "--:--",
      "hoursWorked": "0h",
      "status": "Leave"
    },
    {
      "date": "2026-06-15",
      "checkIn": "09:30 AM",
      "checkOut": "01:00 PM",
      "hoursWorked": "3h 30m",
      "status": "Half Day"
    },
    {
      "date": "2026-06-14",
      "checkIn": "08:55 AM",
      "checkOut": "06:15 PM",
      "hoursWorked": "9h 20m",
      "status": "Present"
    },
    {
      "date": "2026-06-13",
      "checkIn": "09:05 AM",
      "checkOut": "06:00 PM",
      "hoursWorked": "8h 55m",
      "status": "Present"
    },
  ];

  final List<Map<String, dynamic>> _mockStaffPayslips = [
    {
      "month": "June 2026",
      "baseSalary": 30000,
      "pf": 1800,
      "esi": 250,
      "incentive": 2500,
      "deductions": 2050,
      "netPay": 30450,
      "leavesTaken": 2,
      "totalWorkingDays": 22
    },
    {
      "month": "May 2026",
      "baseSalary": 30000,
      "pf": 1800,
      "esi": 250,
      "incentive": 3200,
      "deductions": 2050,
      "netPay": 31150,
      "leavesTaken": 1,
      "totalWorkingDays": 23
    },
    {
      "month": "April 2026",
      "baseSalary": 30000,
      "pf": 1800,
      "esi": 250,
      "incentive": 1800,
      "deductions": 2050,
      "netPay": 29750,
      "leavesTaken": 3,
      "totalWorkingDays": 21
    },
  ];

  final List<Map<String, dynamic>> _mockStaffIncentives = [
    {
      "id": "inc1",
      "date": "2026-06-19",
      "type": "AMC Commission",
      "amount": 1000.0,
      "description": "Acme Corp - AMC visit completed"
    },
    {
      "id": "inc2",
      "date": "2026-06-17",
      "type": "Installation Bonus",
      "amount": 1500.0,
      "description": "Sunrise Apartments - Installation done"
    }
  ];

  final List<Map<String, dynamic>> _mockCustomerProducts = [
    {
      "id": "cp1",
      "name": "Eco Water Purifier RO+UV",
      "model": "EcoPure-2025",
      "serialNumber": "GGT-WP-99281",
      "installDate": "2025-01-10",
      "warrantyStart": "2025-01-10",
      "warrantyEnd": "2027-01-10",
      "status": "Active",
      "coveredItems": ["Pump", "Membrane", "Carbon Filter", "Sediment Filter"]
    },
    {
      "id": "cp2",
      "name": "Under-Sink Alkaline RO",
      "model": "GG-AL-15LPH",
      "serialNumber": "GGT-WP-88734",
      "installDate": "2024-05-20",
      "warrantyStart": "2024-05-20",
      "warrantyEnd": "2025-05-20",
      "status": "Warranty Expired",
      "coveredItems": ["Filters", "Adapter"]
    }
  ];


  final List<Map<String, dynamic>> _mockCustomerServiceRequests = [

    {
      "id": "csr1",
      "type": "Complaint",
      "status": "Open",
      "date": "2026-06-19",
      "description": "Low water pressure from purifier tap and noise from booster pump.",
      "assignedTechnician": "Jane Smith",
      "productName": "Eco Water Purifier RO+UV"
    },

    {
      "id": "csr2",
      "type": "AMC Visit",
      "status": "Scheduled",
      "date": "2026-06-25",
      "description": "Regular quarterly maintenance visit. Filter check and TDS testing.",
      "assignedTechnician": "Mike Johnson",
      "productName": "Eco Water Purifier RO+UV"
    },

    {
      "id": "csr3",
      "type": "Installation",
      "status": "Resolved",
      "date": "2025-01-10",
      "description": "Installation of new Eco Water Purifier RO+UV system.",
      "assignedTechnician": "Jane Smith",
      "productName": "Eco Water Purifier RO+UV"
    }
  ];


  final List<Map<String, dynamic>> _mockCustomerInvoices = [
    {
      "id": "inv1",
      "type": "AMC Renewal",
      "date": "2026-01-05",
      "amount": 4500.0,
      "status": "Paid",
      "description": "Annual Maintenance Contract (AMC) for Eco Water Purifier (2026-2027)"
    },
    {
      "id": "inv2",
      "type": "Service Charge",
      "date": "2025-08-14",
      "amount": 850.0,
      "status": "Paid",
      "description": "Out-of-warranty sediment filter replacement for Under-Sink Alkaline RO"
    },
    {
      "id": "inv3",
      "type": "Installation",
      "date": "2025-01-10",
      "amount": 16500.0,
      "status": "Paid",
      "description": "Purchase and installation of Eco Water Purifier RO+UV"
    }
  ];
}