import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_models.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

// Customer Repository Provider
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CustomerRepositoryImpl(dioClient);
});

// 1. Dashboard Metrics State & Notifier
class CustomerDashboardState {
  final bool isLoading;
  final CustomerDashboardMetrics? metrics;
  final String? error;

  CustomerDashboardState({this.isLoading = false, this.metrics, this.error});
}

class CustomerDashboardNotifier extends StateNotifier<CustomerDashboardState> {
  final CustomerRepository _repository;

  CustomerDashboardNotifier(this._repository)
    : super(CustomerDashboardState()) {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    state = CustomerDashboardState(isLoading: true);
    try {
      final metrics = await _repository.getDashboardMetrics();
      state = CustomerDashboardState(metrics: metrics);
    } catch (e) {
      state = CustomerDashboardState(error: e.toString());
    }
  }
}

final customerDashboardProvider =
    StateNotifierProvider<CustomerDashboardNotifier, CustomerDashboardState>((
      ref,
    ) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomerDashboardNotifier(repository);
    });

// 2. Customer Products State & Notifier
class CustomerProductsState {
  final bool isLoading;
  final List<CustomerProduct> products;
  final String? error;

  CustomerProductsState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });
}

class CustomerProductsNotifier extends StateNotifier<CustomerProductsState> {
  final CustomerRepository _repository;

  CustomerProductsNotifier(this._repository) : super(CustomerProductsState()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    state = CustomerProductsState(isLoading: true, products: state.products);
    try {
      final products = await _repository.getProducts();
      state = CustomerProductsState(products: products);
    } catch (e) {
      state = CustomerProductsState(
        error: e.toString(),
        products: state.products,
      );
    }
  }
}

final customerProductsProvider =
    StateNotifierProvider<CustomerProductsNotifier, CustomerProductsState>((
      ref,
    ) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomerProductsNotifier(repository);
    });

// 3. Customer Service Requests State & Notifier
class CustomerServiceRequestsState {
  final bool isLoading;
  final List<CustomerServiceRequest> requests;
  final String? error;

  CustomerServiceRequestsState({
    this.isLoading = false,
    this.requests = const [],
    this.error,
  });
}

class CustomerServiceRequestsNotifier
    extends StateNotifier<CustomerServiceRequestsState> {
  final CustomerRepository _repository;

  CustomerServiceRequestsNotifier(this._repository)
    : super(CustomerServiceRequestsState()) {
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    state = CustomerServiceRequestsState(
      isLoading: true,
      requests: state.requests,
    );
    try {
      final requests = await _repository.getServiceRequests();
      state = CustomerServiceRequestsState(requests: requests);
    } catch (e) {
      state = CustomerServiceRequestsState(
        error: e.toString(),
        requests: state.requests,
      );
    }
  }
}

final customerServiceRequestsProvider =
    StateNotifierProvider<
      CustomerServiceRequestsNotifier,
      CustomerServiceRequestsState
    >((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomerServiceRequestsNotifier(repository);
    });

// 4. Customer Invoices State & Notifier
class CustomerInvoicesState {
  final bool isLoading;
  final List<CustomerInvoice> invoices;
  final String? error;

  CustomerInvoicesState({
    this.isLoading = false,
    this.invoices = const [],
    this.error,
  });
}

class CustomerInvoicesNotifier extends StateNotifier<CustomerInvoicesState> {
  final CustomerRepository _repository;

  CustomerInvoicesNotifier(this._repository) : super(CustomerInvoicesState()) {
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    state = CustomerInvoicesState(isLoading: true, invoices: state.invoices);
    try {
      final invoices = await _repository.getInvoices();
      state = CustomerInvoicesState(invoices: invoices);
    } catch (e) {
      state = CustomerInvoicesState(
        error: e.toString(),
        invoices: state.invoices,
      );
    }
  }
}

final customerInvoicesProvider =
    StateNotifierProvider<CustomerInvoicesNotifier, CustomerInvoicesState>((
      ref,
    ) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomerInvoicesNotifier(repository);
    });
