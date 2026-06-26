import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/adaptive/adaptive_widgets.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';
import '../admin_dashboard_screen.dart';

class AdminCustomersView extends ConsumerStatefulWidget {
  const AdminCustomersView({super.key});

  @override
  ConsumerState<AdminCustomersView> createState() => _AdminCustomersViewState();
}

class _AdminCustomersViewState extends ConsumerState<AdminCustomersView> {
  String _categoryFilter = 'All Categories';
  String _amcFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final customersState = ref.watch(adminCustomersProvider);
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    if (customersState.isLoading) {
      return const Center(
        child: AdaptiveProgressIndicator(radius: 20),
      );
    }

    if (customersState.error != null) {
      return Center(
        child: Text('Error loading customers: ${customersState.error}'),
      );
    }

    // Filter customers
    final filteredCustomers = customersState.customers.where((customer) {
      final matchesCategory = _categoryFilter == 'All Categories' || customer.category == _categoryFilter;
      final matchesAmc = _amcFilter == 'All' || customer.amcStatus == _amcFilter;
      final matchesSearch = customer.name.toLowerCase().contains(searchQuery) ||
          customer.id.toLowerCase().contains(searchQuery) ||
          customer.phone.contains(searchQuery) ||
          customer.address.toLowerCase().contains(searchQuery);

      return matchesCategory && matchesAmc && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action Header (Export & Add New Customer)
        _buildActionHeader(context),
        const SizedBox(height: 16),

        // Filters Toolbar
        _buildFiltersToolbar(),
        const SizedBox(height: 16),

        // Customer Cards List
        Expanded(
          child: filteredCustomers.isEmpty
              ? const Center(child: Text('No customers match the current filter or search criteria.'))
              : ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];
                    return _buildCustomerCard(context, customer);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActionHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 500;

    return Row(
      children: [
        const Text(
          'Customer Accounts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.onSurfaceColor),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _showAddCustomerDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.onSurfaceColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(isMobile ? 'New' : 'New Customer'),
        ),
      ],
    );
  }

  Widget _buildFiltersToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _categoryFilter,
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.outlineColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _categoryFilter = newValue);
                  }
                },
                items: <String>['All Categories', 'Commercial', 'Residential']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // AMC Status Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _amcFilter,
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.outlineColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _amcFilter = newValue);
                  }
                },
                items: <String>['All', 'Active', 'Due Soon', 'Expired']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == 'All' ? 'AMC Status: All' : 'AMC: $value'),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, Customer customer) {
    Color badgeColor;
    Color badgeBg;
    IconData amcIcon;

    switch (customer.amcStatus) {
      case 'Active':
        badgeColor = Colors.green;
        badgeBg = Colors.green.withOpacity(0.08);
        amcIcon = Icons.shield;
        break;
      case 'Due Soon':
        badgeColor = Colors.amber.shade800;
        badgeBg = Colors.amber.shade50;
        amcIcon = Icons.warning_amber_rounded;
        break;
      default:
        badgeColor = AppTheme.errorColor;
        badgeBg = AppTheme.errorColor.withOpacity(0.08);
        amcIcon = Icons.error_outline;
    }

    final isCommercial = customer.category == 'Commercial';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & ID row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              customer.id,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isCommercial
                                  ? AppTheme.primaryColor.withOpacity(0.08)
                                  : AppTheme.secondaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              customer.category,
                              style: TextStyle(
                                color: isCommercial ? AppTheme.primaryColor : AppTheme.secondaryColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: badgeColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(amcIcon, color: badgeColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        customer.amcStatus,
                        style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Contact Info
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: AppTheme.outlineColor),
                const SizedBox(width: 8),
                Text(customer.phone, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.outlineColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    customer.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bottom Products + Renewal Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${customer.products.length} Products Installed',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.onSurfaceVariantColor),
                ),
                Text(
                  'Renewal: ${customer.nextAmcDate}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.outlineColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show "New Customer" input form dialog
  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    String category = 'Commercial';
    String amcStatus = 'Active';
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              backgroundColor: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
              title: const Text('New Customer', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveTextField(
                        controller: nameController,
                        labelText: 'Customer Name',
                        hintText: 'Enter customer name',
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AdaptiveTextField(
                        controller: phoneController,
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      AdaptiveTextField(
                        controller: addressController,
                        labelText: 'Address',
                        hintText: 'Enter address details',
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Category
                      const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          ChoiceChip(
                            label: const Text('Commercial'),
                            selected: category == 'Commercial',
                            onSelected: (_) => setStateBuilder(() => category = 'Commercial'),
                          ),
                          ChoiceChip(
                            label: const Text('Residential'),
                            selected: category == 'Residential',
                            onSelected: (_) => setStateBuilder(() => category = 'Residential'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // AMC Status
                      const Text('AMC Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: amcStatus,
                        dropdownColor: isDark ? AppTheme.darkSurfaceContainerColor : Colors.white,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        onChanged: (val) => setStateBuilder(() => amcStatus = val!),
                        items: ['Active', 'Due Soon', 'Expired'].map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                AdaptiveButton(
                  type: AdaptiveButtonType.text,
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                AdaptiveButton(
                  type: AdaptiveButtonType.filled,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final success = await ref.read(adminCustomersProvider.notifier).addCustomer({
                        'name': nameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'address': addressController.text.trim(),
                        'category': category,
                        'amcStatus': amcStatus,
                      });

                      if (success && mounted) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Customer registered successfully.')),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
