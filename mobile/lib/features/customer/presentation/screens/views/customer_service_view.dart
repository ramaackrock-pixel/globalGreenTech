import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/customer_models.dart';
import '../../controllers/customer_controller.dart';

class CustomerServiceView extends ConsumerStatefulWidget {
  const CustomerServiceView({super.key});

  @override
  ConsumerState<CustomerServiceView> createState() => _CustomerServiceViewState();
}

class _CustomerServiceViewState extends ConsumerState<CustomerServiceView> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Complaint';
  String _selectedProduct = '';
  final _descriptionController = TextEditingController();
  List<CustomerServiceRequest> _localRequests = [];
  bool _hasLoadedLocal = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showNewRequestBottomSheet(
    BuildContext context,
    List<CustomerProduct> products,

  ) {
    if (products.isNotEmpty && _selectedProduct.isEmpty) {
      _selectedProduct = products.first.name;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Raise Service Request',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Request Type',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Complaint', 'AMC Visit', 'Installation']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _selectedType = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedProduct.isNotEmpty ? _selectedProduct : (products.isNotEmpty ? products.first.name : ''),
                      decoration: const InputDecoration(
                        labelText: 'Select Product',
                        border: OutlineInputBorder(),
                      ),
                      items: products
                          .map((prod) => DropdownMenuItem(
                                value: prod.name,
                                child: Text(prod.name),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _selectedProduct = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description / Issue details',
                        hintText: 'Please describe the issue or service requested...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newRequest = CustomerServiceRequest(
                              id: 'csr_${DateTime.now().millisecondsSinceEpoch}',
                              type: _selectedType,
                              status: 'Open',
                              date: DateTime.now().toString().split(' ').first,
                              description: _descriptionController.text.trim(),
                              assignedTechnician: 'Pending Assignment',
                              productName: _selectedProduct,
                            );

                            setState(() {
                              _localRequests.insert(0, newRequest);
                            });

                            _descriptionController.clear();
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Service request raised successfully!'),
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Submit Request', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(customerServiceRequestsProvider);
    final productsState = ref.watch(customerProductsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (requestsState.isLoading || productsState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (requestsState.error != null) {
      return Center(child: Text('Error: ${requestsState.error}'));
    }

    if (!_hasLoadedLocal) {
      _localRequests = List.from(requestsState.requests);
      _hasLoadedLocal = true;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewRequestBottomSheet(context, productsState.products),
        icon: const Icon(Icons.add),
        label: const Text('Raise Request'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(customerServiceRequestsProvider.notifier).fetchServiceRequests();
          ref.read(customerProductsProvider.notifier).fetchProducts();
          setState(() {
            _hasLoadedLocal = false;
          });
        },
        child: _localRequests.isEmpty
            ? const Center(child: Text('No service requests found.'))
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _localRequests.length,
                itemBuilder: (context, index) {
                  final req = _localRequests[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getRequestIcon(req.type),
                                    color: _getRequestColor(req.type),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    req.type,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              _buildStatusChip(req.status, isDark),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            req.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      req.productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Technician',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      req.assignedTechnician,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Date',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      req.date,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color chipColor;
    switch (status) {
      case 'Resolved':
        chipColor = const Color(0xFF2E7D32);
        break;
      case 'In Progress':
        chipColor = AppTheme.tertiaryColor;
        break;
      case 'Scheduled':
        chipColor = AppTheme.secondaryColor;
        break;
      default:
        chipColor = AppTheme.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getRequestIcon(String type) {
    switch (type) {
      case 'Complaint':
        return Icons.warning_amber_outlined;
      case 'AMC Visit':
        return Icons.build_outlined;
      case 'Installation':
        return Icons.construction_outlined;
      default:
        return Icons.task_outlined;
    }
  }

  Color _getRequestColor(String type) {
    switch (type) {
      case 'Complaint':
        return AppTheme.errorColor;
      case 'AMC Visit':
        return AppTheme.secondaryColor;
      case 'Installation':
        return AppTheme.tertiaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
