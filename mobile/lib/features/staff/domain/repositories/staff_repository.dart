import '../../data/models/staff_models.dart';
import '../../../admin/data/models/admin_models.dart';

abstract class StaffRepository {
  Future<StaffDashboardMetrics> getDashboardMetrics();
  Future<List<StaffTask>> getTasks();
  Future<List<AttendanceRecord>> getAttendance();
  Future<List<StaffPayslip>> getPayslips();
  Future<List<InventoryItem>> getInventory();
  Future<List<StaffIncentiveRecord>> getIncentives();
}
