import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../controllers/customer_controller.dart';

class CustomerBillingView extends ConsumerWidget {
  const CustomerBillingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingState = ref.watch(customerInvoicesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (billingState.isLoading) {
      return const Center(
        child: SpinKitFadingCircle(color: AppTheme.primaryColor, size: 50.0),
      );
    }

    if (billingState.error != null) {
      return Center(child: Text('Error: ${billingState.error}'));
    }

    final invoices = billingState.invoices;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(customerInvoicesProvider.notifier).fetchInvoices();
      },
      child: invoices.isEmpty
          ? const Center(child: Text('No billing records found.'))
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final isPaid = inv.status.toLowerCase() == 'paid';
                final isPending = inv.status.toLowerCase() == 'pending';

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
                            Text(
                              inv.type,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isPaid
                                        ? const Color(0xFF2E7D32)
                                        : isPending
                                            ? AppTheme.secondaryColor
                                            : AppTheme.errorColor)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                inv.status,
                                style: TextStyle(
                                  color: isPaid
                                      ? const Color(0xFF2E7D32)
                                      : isPending
                                          ? AppTheme.secondaryColor
                                          : AppTheme.errorColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invoice ID: ${inv.id}  |  Date: ${inv.date}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          inv.description,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount Due',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark ? AppTheme.darkOnSurfaceVariantColor : AppTheme.onSurfaceVariantColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹ ${inv.amount.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isPaid ? null : AppTheme.errorColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isPaid
                                        ? 'Downloading invoice ${inv.id}...'
                                        : 'Redirecting to payment gateway for ₹ ${inv.amount.toStringAsFixed(2)}...'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: Icon(isPaid ? Icons.download : Icons.payment, size: 16),
                              label: Text(isPaid ? 'Download' : 'Pay Now'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
