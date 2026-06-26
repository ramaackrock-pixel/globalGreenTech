import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/admin_models.dart';

class AdminRepositoryImpl implements AdminRepository {
  final DioClient _dioClient;

  // In-memory lists for dynamic updates during session
  List<Customer>? _customers;
  List<InventoryItem>? _inventory;
  List<ServiceTask>? _tasks;
  List<Staff>? _staff;

  AdminRepositoryImpl(this._dioClient);

  @override
  Future<DashboardMetrics> getMetrics() async {
    // If lists are loaded, calculate metrics dynamically, else fetch from endpoint
    if (_customers != null && _inventory != null && _tasks != null) {
      final lowStock = _inventory!.where((i) => i.isLowStock).length;
      final openComplaints = _tasks!.where((t) => t.type == 'Complaint' && t.status == 'Open').length;
      return DashboardMetrics(
        totalCustomers: _customers!.length,
        openComplaints: openComplaints,
        lowStockAlerts: lowStock,
        todayRevenue: '₹ 15,400', // Mock hardcoded revenue
      );
    }

    final response = await _dioClient.get(ApiEndpoints.adminDashboardMetrics);
    return DashboardMetrics.fromJson(response.data);
  }

  @override
  Future<List<Customer>> getCustomers() async {
    if (_customers != null) return _customers!;
    
    final response = await _dioClient.get(ApiEndpoints.adminCustomers);
    final list = (response.data as List).map((e) => Customer.fromJson(e)).toList();
    _customers = list;
    return _customers!;
  }

  @override
  Future<List<InventoryItem>> getInventory() async {
    if (_inventory != null) return _inventory!;

    final response = await _dioClient.get(ApiEndpoints.adminInventory);
    final list = (response.data as List).map((e) => InventoryItem.fromJson(e)).toList();
    _inventory = list;
    return _inventory!;
  }

  @override
  Future<List<ServiceTask>> getTasks() async {
    if (_tasks != null) return _tasks!;

    final response = await _dioClient.get(ApiEndpoints.adminTasks);
    final list = (response.data as List).map((e) => ServiceTask.fromJson(e)).toList();
    _tasks = list;
    return _tasks!;
  }

  @override
  Future<List<Staff>> getStaff() async {
    if (_staff != null) return _staff!;

    final response = await _dioClient.get(ApiEndpoints.adminUsers);
    final list = (response.data as List).map((e) => Staff.fromJson(e)).toList();
    _staff = list;
    return _staff!;
  }

  @override
  Future<void> saveCustomer(Map<String, dynamic> customerData) async {
    // Ensure customers are loaded first
    await getCustomers();
    
    final newId = 'c${_customers!.length + 1}';
    final customer = Customer(
      id: newId,
      name: customerData['name'] ?? '',
      category: customerData['category'] ?? 'Commercial',
      phone: customerData['phone'] ?? '',
      address: customerData['address'] ?? '',
      amcStatus: customerData['amcStatus'] ?? 'Active',
      nextAmcDate: customerData['nextAmcDate'] ?? DateTime.now().add(const Duration(days: 365)).toString().substring(0, 10),
      products: [],
    );
    
    _customers!.add(customer);
  }

  @override
  Future<void> saveInventoryItem(Map<String, dynamic> itemData) async {
    // Ensure inventory is loaded first
    await getInventory();

    final newId = 'i${_inventory!.length + 1}';
    final item = InventoryItem(
      id: newId,
      name: itemData['name'] ?? '',
      sku: itemData['sku'] ?? '',
      price: (itemData['price'] as num?)?.toDouble() ?? 0.0,
      stock: (itemData['stock'] as num?)?.toInt() ?? 0,
      minStockAlert: (itemData['minStockAlert'] as num?)?.toInt() ?? 10,
    );

    _inventory!.add(item);
  }
}
