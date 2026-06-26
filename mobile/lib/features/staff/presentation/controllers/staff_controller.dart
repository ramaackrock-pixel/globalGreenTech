import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/staff_models.dart';
import '../../../admin/data/models/admin_models.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

// Staff Repository Provider
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return StaffRepositoryImpl(dioClient);
});

// 1. Dashboard Metrics State & Notifier
class StaffDashboardState {
  final bool isLoading;
  final StaffDashboardMetrics? metrics;
  final String? error;

  StaffDashboardState({this.isLoading = false, this.metrics, this.error});
}

class StaffDashboardNotifier extends StateNotifier<StaffDashboardState> {
  final StaffRepository _repository;

  StaffDashboardNotifier(this._repository) : super(StaffDashboardState()) {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    state = StaffDashboardState(isLoading: true);
    try {
      final metrics = await _repository.getDashboardMetrics();
      state = StaffDashboardState(metrics: metrics);
    } catch (e) {
      state = StaffDashboardState(error: e.toString());
    }
  }
}

final staffDashboardProvider =
    StateNotifierProvider<StaffDashboardNotifier, StaffDashboardState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffDashboardNotifier(repository);
});

// 2. Staff Tasks State & Notifier
class StaffTasksState {
  final bool isLoading;
  final List<StaffTask> tasks;
  final String? error;

  StaffTasksState({this.isLoading = false, this.tasks = const [], this.error});
}

class StaffTasksNotifier extends StateNotifier<StaffTasksState> {
  final StaffRepository _repository;

  StaffTasksNotifier(this._repository) : super(StaffTasksState()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    state = StaffTasksState(isLoading: true, tasks: state.tasks);
    try {
      final tasks = await _repository.getTasks();
      state = StaffTasksState(tasks: tasks);
    } catch (e) {
      state = StaffTasksState(error: e.toString(), tasks: state.tasks);
    }
  }
}

final staffTasksProvider =
    StateNotifierProvider<StaffTasksNotifier, StaffTasksState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffTasksNotifier(repository);
});

// 3. Staff Attendance State & Notifier
class StaffAttendanceState {
  final bool isLoading;
  final List<AttendanceRecord> records;
  final String? error;

  StaffAttendanceState({this.isLoading = false, this.records = const [], this.error});
}

class StaffAttendanceNotifier extends StateNotifier<StaffAttendanceState> {
  final StaffRepository _repository;

  StaffAttendanceNotifier(this._repository) : super(StaffAttendanceState()) {
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    state = StaffAttendanceState(isLoading: true, records: state.records);
    try {
      final records = await _repository.getAttendance();
      state = StaffAttendanceState(records: records);
    } catch (e) {
      state = StaffAttendanceState(error: e.toString(), records: state.records);
    }
  }
}

final staffAttendanceProvider =
    StateNotifierProvider<StaffAttendanceNotifier, StaffAttendanceState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffAttendanceNotifier(repository);
});

// 4. Staff Payslip State & Notifier
class StaffPayslipState {
  final bool isLoading;
  final List<StaffPayslip> payslips;
  final String? error;

  StaffPayslipState({this.isLoading = false, this.payslips = const [], this.error});
}

class StaffPayslipNotifier extends StateNotifier<StaffPayslipState> {
  final StaffRepository _repository;

  StaffPayslipNotifier(this._repository) : super(StaffPayslipState()) {
    fetchPayslips();
  }

  Future<void> fetchPayslips() async {
    state = StaffPayslipState(isLoading: true, payslips: state.payslips);
    try {
      final payslips = await _repository.getPayslips();
      state = StaffPayslipState(payslips: payslips);
    } catch (e) {
      state = StaffPayslipState(error: e.toString(), payslips: state.payslips);
    }
  }
}

final staffPayslipProvider =
    StateNotifierProvider<StaffPayslipNotifier, StaffPayslipState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffPayslipNotifier(repository);
});

// 5. Staff Inventory State & Notifier
class StaffInventoryState {
  final bool isLoading;
  final List<InventoryItem> items;
  final String? error;

  StaffInventoryState({this.isLoading = false, this.items = const [], this.error});
}

class StaffInventoryNotifier extends StateNotifier<StaffInventoryState> {
  final StaffRepository _repository;

  StaffInventoryNotifier(this._repository) : super(StaffInventoryState()) {
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    state = StaffInventoryState(isLoading: true, items: state.items);
    try {
      final items = await _repository.getInventory();
      state = StaffInventoryState(items: items);
    } catch (e) {
      state = StaffInventoryState(error: e.toString(), items: state.items);
    }
  }
}

final staffInventoryProvider =
    StateNotifierProvider<StaffInventoryNotifier, StaffInventoryState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffInventoryNotifier(repository);
});

// 6. Staff Incentives State & Notifier
class StaffIncentivesState {
  final bool isLoading;
  final List<StaffIncentiveRecord> records;
  final String? error;

  StaffIncentivesState({this.isLoading = false, this.records = const [], this.error});
}

class StaffIncentivesNotifier extends StateNotifier<StaffIncentivesState> {
  final StaffRepository _repository;

  StaffIncentivesNotifier(this._repository) : super(StaffIncentivesState()) {
    fetchIncentives();
  }

  Future<void> fetchIncentives() async {
    state = StaffIncentivesState(isLoading: true, records: state.records);
    try {
      final records = await _repository.getIncentives();
      state = StaffIncentivesState(records: records);
    } catch (e) {
      state = StaffIncentivesState(error: e.toString(), records: state.records);
    }
  }
}

final staffIncentivesProvider =
    StateNotifierProvider<StaffIncentivesNotifier, StaffIncentivesState>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return StaffIncentivesNotifier(repository);
});
