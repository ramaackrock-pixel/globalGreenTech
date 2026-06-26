import '../../data/models/admin_models.dart';

abstract class AdminRepository {
  Future<DashboardMetrics> getMetrics();
  Future<List<Customer>> getCustomers();
  Future<List<InventoryItem>> getInventory();
  Future<List<ServiceTask>> getTasks();
  Future<List<Staff>> getStaff();
  Future<void> saveCustomer(Map<String, dynamic> customerData);
  Future<void> saveInventoryItem(Map<String, dynamic> itemData);
}
