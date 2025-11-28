import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/order_controller.dart';

class OrderHistoryView extends ConsumerWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Order #${order.id.substring(0, 6)}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${order.date}'),
                  Text('Items: ${order.items.length}'),
                  Text('Total: ${order.totalPrice} \$'),
                  if (order.discount > 0) Text('Discount: ${order.discount} \$'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
