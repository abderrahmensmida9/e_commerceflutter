import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime date;
  final double discount;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
    this.discount = 0.0,
  });
}
