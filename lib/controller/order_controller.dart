// lib/controller/order_controller.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../model/order.dart' as myModel;
import '../model/cart_item.dart';
import '../model/product.dart';
import '../model/coupon.dart';
import 'cart_controller.dart';
import 'auth_controller.dart';
import 'package:uuid/uuid.dart';

class OrderController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController auth;
  final CartController cartController;

  List<myModel.Order> orders = [];

  OrderController({required this.auth, required this.cartController});

  // Passer une commande
  Future<void> placeOrder({Coupon? coupon}) async {
    final cartItems = cartController.cartItems;
    if (cartItems.isEmpty || auth.currentUser == null) return;

    double discount = 0.0;
    final total = cartItems.fold<double>(
        0, (sum, item) => sum + item.product.price * item.quantity);

    if (coupon != null) {
      discount = total * (coupon.discountPercent / 100);
    }

    final orderId = const Uuid().v4();
    final newOrder = myModel.Order(
      id: orderId,
      items: List.from(cartItems),
      totalPrice: total - discount,
      date: DateTime.now(),
      discount: discount,
    );

    // Sauvegarder sur Firestore
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
                // ✅ CORRECTION 5 : Sauvegarde de la catégorie dans la commande
                'category': e.product.category, 
                // Il serait également bon d'ajouter 'imageUrl' et 'description' si vous les utilisez
                'imageUrl': e.product.imageUrl, 
                'description': e.product.description,
              })
          .toList(),
      'totalPrice': newOrder.totalPrice,
      'discount': newOrder.discount,
      'date': newOrder.date.toIso8601String(),
    });

    orders.add(newOrder);
    cartController.clearCart();
    notifyListeners();
  }

  // Charger l’historique des commandes
  Future<void> loadOrders() async {
    if (auth.currentUser == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('orders')
        .get();

    orders = snapshot.docs.map((doc) {
      final data = doc.data();
      final List<CartItem> itemsData = (data['items'] as List)
          .map((e) => CartItem(
                product: Product(
                  id: e['productId'],
                  name: e['name'],
                  // Assurez-vous que les données sont lues ou définissez une valeur par défaut si non sauvegardées
                  description: e['description'] ?? '', 
                  price: (e['price'] as num).toDouble(),
                  imageUrl: e['imageUrl'] ?? '',
                  // ✅ CORRECTION 6 : Lecture de la catégorie pour le modèle Product
                  category: e['category'] ?? '', 
                ),
                quantity: (e['quantity'] as num).toInt(),
              ))
          .toList();

      return myModel.Order(
        id: doc.id,
        items: itemsData,
        totalPrice: (data['totalPrice'] as num).toDouble(),
        date: DateTime.parse(data['date']),
        discount: (data['discount'] as num).toDouble(),
      );
    }).toList();

    notifyListeners();
  }
}