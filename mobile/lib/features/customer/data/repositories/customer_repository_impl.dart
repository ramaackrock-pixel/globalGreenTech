import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/customer_repository.dart';
import '../models/customer_models.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final DioClient _dioClient;

  CustomerRepositoryImpl(this._dioClient);

  @override
  Future<CustomerDashboardMetrics> getDashboardMetrics() async {
    final response = await _dioClient.get(ApiEndpoints.customerDashboard);
    return CustomerDashboardMetrics.fromJson(response.data);
  }

  @override
  Future<List<CustomerProduct>> getProducts() async {
    final response = await _dioClient.get(ApiEndpoints.customerProducts);
    final list = (response.data as List)
        .map((e) => CustomerProduct.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<CustomerServiceRequest>> getServiceRequests() async {
    final response = await _dioClient.get(ApiEndpoints.customerServiceRequests);
    final list = (response.data as List)
        .map((e) => CustomerServiceRequest.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<CustomerInvoice>> getInvoices() async {
    final response = await _dioClient.get(ApiEndpoints.customerInvoices);
    final list = (response.data as List)
        .map((e) => CustomerInvoice.fromJson(e))
        .toList();
    return list;
  }

  @override
  Future<List<MarketProduct>> getMarketplaceProducts() async {
    final response = await _dioClient.get(ApiEndpoints.marketplaceProducts);
    final list = (response.data as List)
        .map((e) => MarketProduct.fromJson(e))
        .toList();
    return list;
  }
}
