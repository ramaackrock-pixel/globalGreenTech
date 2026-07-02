import '../../data/models/customer_models.dart';

abstract class CustomerRepository {
  Future<CustomerDashboardMetrics> getDashboardMetrics();
  Future<List<CustomerProduct>> getProducts();
  Future<List<CustomerServiceRequest>> getServiceRequests();
  Future<List<CustomerInvoice>> getInvoices();
  Future<List<MarketProduct>> getMarketplaceProducts();
}
