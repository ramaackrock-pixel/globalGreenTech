import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/admin_controller.dart';
import '../../../data/models/admin_models.dart';
import '../admin_dashboard_screen.dart';

class AdminInventoryView extends ConsumerStatefulWidget {
  const AdminInventoryView({super.key});

  @override
  ConsumerState<AdminInventoryView> createState() => _AdminInventoryViewState();
}

class _AdminInventoryViewState extends ConsumerState<AdminInventoryView> {
  bool _onlyLowStock = false;

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(adminInventoryProvider);
    final searchQuery = ref.watch(adminSearchQueryProvider).toLowerCase();

    if (inventoryState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(
          color: AppTheme.primaryColor,
          size: 50.0,
        ),
      );
    }

    if (inventoryState.error != null) {
      return Center(
        child: Text('Error loading inventory: ${inventoryState.error}'),
      );
    }

    // Filter items
    final filteredItems = inventoryState.items.where((item) {
      final matchesAlert = !_onlyLowStock || item.isLowStock;
      final matchesSearch = item.name.toLowerCase().contains(searchQuery) ||
          item.sku.toLowerCase().contains(searchQuery) ||
          item.id.toLowerCase().contains(searchQuery);

      return matchesAlert && matchesSearch;
    }).toList();

    final totalAlerts = inventoryState.items.where((i) => i.isLowStock).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top level Actions
        _buildActionHeader(context, totalAlerts),
        const SizedBox(height: 16),

        // Filter chips bar
        _buildFilterChipsBar(),
        const SizedBox(height: 16),

        // List
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(child: Text('No inventory items found matching filters.'))
              : ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _buildInventoryCard(context, item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActionHeader(BuildContext context, int alertCount) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 500;

    return Row(
      children: [
        Text(
          'Inventory Stocks',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        if (alertCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$alertCount Alert${alertCount > 1 ? 's' : ''}',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _showAddItemDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.onSurfaceColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(isMobile ? 'Add' : 'New Item'),
        ),
      ],
    );
  }

  Widget _buildFilterChipsBar() {
    return Row(
      children: [
        FilterChip(
          label: const Text('All Items'),
          selected: !_onlyLowStock,
          onSelected: (selected) {
            if (selected) {
              setState(() => _onlyLowStock = false);
            }
          },
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: const Text('Low Stock Alerts'),
          selected: _onlyLowStock,
          selectedColor: AppTheme.errorColor.withOpacity(0.08),
          checkmarkColor: AppTheme.errorColor,
          labelStyle: TextStyle(
            color: _onlyLowStock ? AppTheme.errorColor : AppTheme.onSurfaceVariantColor,
            fontWeight: _onlyLowStock ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            if (selected) {
              setState(() => _onlyLowStock = true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildInventoryCard(BuildContext context, InventoryItem item) {
    final hasAlert = item.isLowStock;
    final progress = item.minStockAlert > 0 ? (item.stock / item.minStockAlert) : 1.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top (Name, SKU, price)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${item.sku}  |  ID: ${item.id}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹ ${item.price.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Stock Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Stock', style: TextStyle(fontSize: 12, color: AppTheme.outlineColor)),
                    const SizedBox(height: 4),
                    Text(
                      '${item.stock} Units',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: hasAlert ? AppTheme.errorColor : AppTheme.onSurfaceColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Alert Threshold', style: TextStyle(fontSize: 12, color: AppTheme.outlineColor)),
                    const SizedBox(height: 4),
                    Text(
                      '${item.minStockAlert} Units',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.onSurfaceColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Warning Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppTheme.surfaceContainerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hasAlert ? AppTheme.errorColor : AppTheme.tertiaryColor,
                    ),
                  ),
                ),
                if (hasAlert) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.report_problem, color: AppTheme.errorColor, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Low stock warning: replenish item immediately.',
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to add new inventory item
  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final alertController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add Inventory Item', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: skuController,
                    decoration: const InputDecoration(labelText: 'SKU Code'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price (₹)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: 'Initial Stock'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: alertController,
                    decoration: const InputDecoration(labelText: 'Min Stock Alert Level'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final success = await ref.read(adminInventoryProvider.notifier).addInventoryItem({
                    'name': nameController.text.trim(),
                    'sku': skuController.text.trim(),
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'stock': int.tryParse(stockController.text) ?? 0,
                    'minStockAlert': int.tryParse(alertController.text) ?? 10,
                  });

                  if (success && mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item registered successfully.')),
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
  }
}
