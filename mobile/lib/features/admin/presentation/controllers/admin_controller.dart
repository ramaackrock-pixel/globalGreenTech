import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_models.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

// Admin Repository Provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminRepositoryImpl(dioClient);
});

// 1. Dashboard Metrics State & Notifier
class AdminMetricsState {
  final bool isLoading;
  final DashboardMetrics? metrics;
  final String? error;

  AdminMetricsState({this.isLoading = false, this.metrics, this.error});
}

class AdminMetricsNotifier extends StateNotifier<AdminMetricsState> {
  final AdminRepository _repository;

  AdminMetricsNotifier(this._repository) : super(AdminMetricsState()) {
    fetchMetrics();
  }

  Future<void> fetchMetrics() async {
    state = AdminMetricsState(isLoading: true);
    try {
      final metrics = await _repository.getMetrics();
      state = AdminMetricsState(metrics: metrics);
    } catch (e) {
      state = AdminMetricsState(error: e.toString());
    }
  }
}

final adminMetricsProvider = StateNotifierProvider<AdminMetricsNotifier, AdminMetricsState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminMetricsNotifier(repository);
});

// 2. Customers List State & Notifier
class AdminCustomersState {
  final bool isLoading;
  final List<Customer> customers;
  final String? error;

  AdminCustomersState({this.isLoading = false, this.customers = const [], this.error});
}

class AdminCustomersNotifier extends StateNotifier<AdminCustomersState> {
  final AdminRepository _repository;
  final Ref _ref;

  AdminCustomersNotifier(this._repository, this._ref) : super(AdminCustomersState()) {
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    state = AdminCustomersState(isLoading: true, customers: state.customers);
    try {
      final customers = await _repository.getCustomers();
      state = AdminCustomersState(customers: customers);
    } catch (e) {
      state = AdminCustomersState(error: e.toString(), customers: state.customers);
    }
  }

  Future<bool> addCustomer(Map<String, dynamic> customerData) async {
    try {
      await _repository.saveCustomer(customerData);
      await fetchCustomers();
      // Also refresh dashboard metrics
      _ref.read(adminMetricsProvider.notifier).fetchMetrics();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminCustomersProvider = StateNotifierProvider<AdminCustomersNotifier, AdminCustomersState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminCustomersNotifier(repository, ref);
});

// 3. Inventory List State & Notifier
class AdminInventoryState {
  final bool isLoading;
  final List<InventoryItem> items;
  final String? error;

  AdminInventoryState({this.isLoading = false, this.items = const [], this.error});
}

class AdminInventoryNotifier extends StateNotifier<AdminInventoryState> {
  final AdminRepository _repository;
  final Ref _ref;

  AdminInventoryNotifier(this._repository, this._ref) : super(AdminInventoryState()) {
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    state = AdminInventoryState(isLoading: true, items: state.items);
    try {
      final items = await _repository.getInventory();
      state = AdminInventoryState(items: items);
    } catch (e) {
      state = AdminInventoryState(error: e.toString(), items: state.items);
    }
  }

  Future<bool> addInventoryItem(Map<String, dynamic> itemData) async {
    try {
      await _repository.saveInventoryItem(itemData);
      await fetchInventory();
      // Also refresh dashboard metrics
      _ref.read(adminMetricsProvider.notifier).fetchMetrics();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminInventoryProvider = StateNotifierProvider<AdminInventoryNotifier, AdminInventoryState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminInventoryNotifier(repository, ref);
});

// 4. Service Tasks List State & Notifier
class AdminTasksState {
  final bool isLoading;
  final List<ServiceTask> tasks;
  final String? error;

  AdminTasksState({this.isLoading = false, this.tasks = const [], this.error});
}

class AdminTasksNotifier extends StateNotifier<AdminTasksState> {
  final AdminRepository _repository;

  AdminTasksNotifier(this._repository) : super(AdminTasksState()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    state = AdminTasksState(isLoading: true, tasks: state.tasks);
    try {
      final tasks = await _repository.getTasks();
      state = AdminTasksState(tasks: tasks);
    } catch (e) {
      state = AdminTasksState(error: e.toString(), tasks: state.tasks);
    }
  }
}

final adminTasksProvider = StateNotifierProvider<AdminTasksNotifier, AdminTasksState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminTasksNotifier(repository);
});

// 5. Staff Users List State & Notifier
class AdminUsersState {
  final bool isLoading;
  final List<Staff> staffList;
  final String? error;

  AdminUsersState({this.isLoading = false, this.staffList = const [], this.error});
}

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final AdminRepository _repository;

  AdminUsersNotifier(this._repository) : super(AdminUsersState()) {
    fetchStaff();
  }

  Future<void> fetchStaff() async {
    state = AdminUsersState(isLoading: true, staffList: state.staffList);
    try {
      final staff = await _repository.getStaff();
      state = AdminUsersState(staffList: staff);
    } catch (e) {
      state = AdminUsersState(error: e.toString(), staffList: state.staffList);
    }
  }
}

final adminUsersProvider = StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminUsersNotifier(repository);
});
