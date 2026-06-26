class ApiEndpoints {
  static const String baseUrl = 'https://api.globalgreentech.com/api';
  
  // Auth
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  
  // Admin Endpoints
  static const String adminDashboardMetrics = '/admin/dashboard';
  static const String adminCustomers = '/admin/customers';
  static const String adminTasks = '/admin/tasks';
  static const String adminInventory = '/admin/inventory';
  static const String adminUsers = '/admin/users';
  
  // Staff Endpoints
  static const String staffDashboard = '/staff/dashboard';
  static const String staffTasks = '/staff/tasks';
  static const String staffAttendance = '/staff/attendance';
  static const String staffPayslip = '/staff/payslip';
  static const String staffInventory = '/staff/inventory';
  static const String staffIncentives = '/staff/incentives';
  
  // Customer Endpoints
  static const String customerDashboard = '/customer/dashboard';
  static const String customerProducts = '/customer/products';
  static const String customerServiceRequests = '/customer/service-requests';
  static const String customerInvoices = '/customer/invoices';
}
