import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/order.dart';
import '../model/cart_item.dart';
import '../model/product.dart';
import '../model/coupon.dart';
import 'cart_controller.dart';
import 'auth_controller.dart';
import 'package:uuid/uuid.dart';

final orderProvider = StateNotifierProvider<OrderController, List<Order>>((ref) {
  return OrderController(ref);
});

class OrderController extends StateNotifier<List<Order>> {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrderController(this.ref) : super([]);

  Future<void> placeOrder({Coupon? coupon}) async {
    final auth = ref.read(authControllerProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = cartNotifier.state;
    if (cartItems.isEmpty || auth.currentUser == null) return;

    double discount = 0.0;
    final total = cartItems.fold<double>(
        0, (sum, item) => sum + item.product.price * item.quantity);
    if (coupon != null) {
      discount = total * (coupon.discountPercent / 100);
    }

    final orderId = const Uuid().v4();
    final newOrder = Order(
      id: orderId,
      items: List.from(cartItems),
      totalPrice: total - discount,
      date: DateTime.now(),
      discount: discount,
    );

    await _firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('orders')
        .doc(orderId)
        .set({
      'items': cartItems
          .map((e) => {
                'productId': e.product.id,
                'name': e.product.name,
                'price': e.product.price,
                'quantity': e.quantity,
              })
          .toList(),
      'totalPrice': newOrder.totalPrice,
      'discount': newOrder.discount,
      'date': newOrder.date.toIso8601String(),
    });

    state = [...state, newOrder];
    cartNotifier.clearCart();
  }

  Future<void> loadOrders() async {
    final auth = ref.read(authControllerProvider);
    if (auth.currentUser == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('orders')
        .get();

    state = snapshot.docs.map((doc) {
      final data = doc.data();

      final List<CartItem> itemsData = (data['items'] as List)
          .map((e) => CartItem(
                product: Product(
                  id: e['productId'],
                  name: e['name'],
                  description: '',
                  price: (e['price'] as num).toDouble(),
                  imageUrl: '',
                ),
                quantity: (e['quantity'] as num).toInt(),
              ))
          .toList();

      return Order(
        id: doc.id,
        items: itemsData,
        totalPrice: (data['totalPrice'] as num).toDouble(),
        date: DateTime.parse(data['date']),
        discount: (data['discount'] as num).toDouble(),
      );
    }).toList();
  }
}
