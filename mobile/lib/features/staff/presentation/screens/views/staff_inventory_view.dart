import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../admin/data/models/admin_models.dart';
import '../../controllers/staff_controller.dart';

class StaffInventoryView extends ConsumerStatefulWidget {
  const StaffInventoryView({super.key});

  @override
  ConsumerState<StaffInventoryView> createState() => _StaffInventoryViewState();
}

class _StaffInventoryViewState extends ConsumerState<StaffInventoryView> {
  bool _onlyLowStock = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(staffInventoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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

    final query = _searchQuery.toLowerCase();
    final filteredItems = inventoryState.items.where((item) {
      final matchesAlert = !_onlyLowStock || item.isLowStock;
      final matchesSearch = item.name.toLowerCase().contains(query) ||
          item.sku.toLowerCase().contains(query) ||
          item.id.toLowerCase().contains(query);
      return matchesAlert && matchesSearch;
    }).toList();

    final totalItems = inventoryState.items.fold<int>(0, (sum, i) => sum + i.stock);
    final lowStockAlertCount = inventoryState.items.where((i) => i.isLowStock).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestPartsBottomSheet(context, inventoryState.items),
        icon: const Icon(Icons.add),
        label: const Text('Request Parts'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(staffInventoryProvider.notifier).fetchInventory();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    title: 'Total Items',
                    value: totalItems.toString(),
                    icon: Icons.inventory_2_outlined,
                    color: AppTheme.primaryColor,
                    bgColor: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.08),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    title: 'Used Today',
                    value: '3',
                    icon: Icons.hardware_outlined,
                    color: AppTheme.secondaryColor,
                    bgColor: (isDark ? AppTheme.darkSecondaryColor : AppTheme.secondaryColor).withOpacity(0.08),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildKpiCard(
                    context: context,
                    title: 'Low Stock',
                    value: lowStockAlertCount.toString(),
                    icon: Icons.warning_amber_outlined,
                    color: lowStockAlertCount > 0 ? AppTheme.errorColor : const Color(0xFF2E7D32),
                    bgColor: (lowStockAlertCount > 0 ? AppTheme.errorColor : const Color(0xFF2E7D32)).withOpacity(0.08),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar & Filter Chips
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search inventory...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Chips
            Row(
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
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Low Stock Alerts'),
                  selected: _onlyLowStock,
                  selectedColor: AppTheme.errorColor.withOpacity(0.08),
                  checkmarkColor: AppTheme.errorColor,
                  labelStyle: TextStyle(
                    color: _onlyLowStock ? AppTheme.errorColor : (isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor),
                    fontWeight: _onlyLowStock ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _onlyLowStock = true);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Inventory List
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text('No inventory items found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final hasAlert = item.isLowStock;
                        final progress = item.minStockAlert > 0 ? (item.stock / item.minStockAlert) : 1.0;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'SKU: ${item.sku}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (hasAlert ? AppTheme.errorColor : const Color(0xFF2E7D32)).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        hasAlert ? 'Low Stock' : 'In Stock',
                                        style: TextStyle(
                                          color: hasAlert ? AppTheme.errorColor : const Color(0xFF2E7D32),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 12),

                                // Stock numbers
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'In Hand: ${item.stock} Units',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      'Min Alert Level: ${item.minStockAlert} Units',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Progress Indicator bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    minHeight: 5,
                                    backgroundColor: isDark
                                        ? AppTheme.darkSurfaceContainerColor
                                        : AppTheme.surfaceContainerColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      hasAlert ? AppTheme.errorColor : AppTheme.tertiaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestPartsBottomSheet(BuildContext context, List<InventoryItem> items) {
    if (items.isEmpty) return;
    String selectedPartId = items.first.id;
    final qtyController = TextEditingController(text: '1');
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Request Spare Parts',
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
                    
                    // Select Part Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedPartId,
                      decoration: const InputDecoration(
                        labelText: 'Select Part',
                        border: OutlineInputBorder(),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item.id,
                                child: Text('${item.name} (${item.sku})'),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedPartId = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quantity Input
                    TextFormField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter quantity';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val <= 0) {
                          return 'Please enter a positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes input
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Describe why you need this part...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Spare parts request submitted successfully to admin!'),
                                backgroundColor: Color(0xFF2E7D32),
                                behavior: SnackBarBehavior.floating,
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
                        child: const Text('Send Request', style: TextStyle(fontWeight: FontWeight.bold)),
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
}
