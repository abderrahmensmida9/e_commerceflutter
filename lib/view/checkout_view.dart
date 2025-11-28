import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/cart_controller.dart';
import '../controller/order_controller.dart';
import '../model/coupon.dart';

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  String? _couponCode;
  Coupon? appliedCoupon;

  final List<Coupon> coupons = [
    Coupon(code: 'WELCOME10', discountPercent: 10),
    Coupon(code: 'SUMMER20', discountPercent: 20),
  ];

  void applyCoupon() {
    final found = coupons.firstWhere(
        (c) => c.code.toUpperCase() == _couponCode?.toUpperCase(),
        orElse: () => Coupon(code: '', discountPercent: 0));
    if (found.discountPercent > 0) {
      setState(() {
        appliedCoupon = found;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coupon ${found.code} applied!')));
    } else {
      setState(() {
        appliedCoupon = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid coupon')));
    }
  }

  void placeOrder() {
    ref.read(orderProvider.notifier).placeOrder(coupon: appliedCoupon);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final total = cart.fold<double>(
        0, (sum, item) => sum + item.product.price * item.quantity);
    final discount = appliedCoupon != null ? total * (appliedCoupon!.discountPercent / 100) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Coupon code'),
              onChanged: (value) => _couponCode = value,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: applyCoupon, child: const Text('Apply Coupon')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cart
                    .map((item) => ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Text('${item.product.price * item.quantity} \$'),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Text('Discount: $discount \$'),
            Text('Total: ${total - discount} \$', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: placeOrder, child: const Text('Place Order'))
          ],
        ),
      ),
    );
  }
}
