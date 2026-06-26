import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/staff_repository.dart';
import '../models/staff_models.dart';

import '../../../admin/data/models/admin_models.dart';

class StaffRepositoryImpl implements StaffRepository {
  final DioClient _dioClient;

  StaffRepositoryImpl(this._dioClient);

  @override
  Future<StaffDashboardMetrics> getDashboardMetrics() async {
    final response = await _dioClient.get(ApiEndpoints.staffDashboard);
    return StaffDashboardMetrics.fromJson(response.data);
  }

  @override
  Future<List<StaffTask>> getTasks() async {
    final response = await _dioClient.get(ApiEndpoints.staffTasks);
    final list = (response.data as List)
        .map((e) => StaffTask.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<AttendanceRecord>> getAttendance() async {
    final response = await _dioClient.get(ApiEndpoints.staffAttendance);
    final list = (response.data as List)
        .map((e) => AttendanceRecord.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<StaffPayslip>> getPayslips() async {
    final response = await _dioClient.get(ApiEndpoints.staffPayslip);
    final list = (response.data as List)
        .map((e) => StaffPayslip.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<InventoryItem>> getInventory() async {
    final response = await _dioClient.get(ApiEndpoints.staffInventory);
    final list = (response.data as List)
        .map((e) => InventoryItem.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<StaffIncentiveRecord>> getIncentives() async {
    final response = await _dioClient.get(ApiEndpoints.staffIncentives);
    final list = (response.data as List)
        .map((e) => StaffIncentiveRecord.fromJson(e))
        .toList();
    return list;
  }
}
