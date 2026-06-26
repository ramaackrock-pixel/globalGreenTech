import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/customer_controller.dart';

class CustomerProductsView extends ConsumerWidget {
  const CustomerProductsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(customerProductsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (productsState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (productsState.error != null) {
      return Center(child: Text('Error: ${productsState.error}'));
    }

    final products = productsState.products;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(customerProductsProvider.notifier).fetchProducts();
      },
      child: products.isEmpty
          ? const Center(child: Text('No installed products found.'))
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isExpired = product.status.toLowerCase().contains('expired');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isExpired ? AppTheme.errorColor : const Color(0xFF2E7D32)).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product.status,
                                style: TextStyle(
                                  color: isExpired ? AppTheme.errorColor : const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Model: ${product.model}  |  S/N: ${product.serialNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateColumn('Installation Date', product.installDate, isDark),
                            _buildDateColumn('Warranty Start', product.warrantyStart, isDark),
                            _buildDateColumn('Warranty End', product.warrantyEnd, isDark),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Covered Components',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.coveredItems.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkSurfaceContainerColor
                                    : AppTheme.surfaceContainerColor,
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.darkOutlineVariantColor
                                      : AppTheme.outlineVariantColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDateColumn(String label, String value, bool isDark) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
