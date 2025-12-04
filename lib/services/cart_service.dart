// lib/services/cart_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------------------------
  //  ADD PRODUCT TO CART
  // ----------------------------
  Future<void> addToCart(Product product) async {
    try {
      final cartRef = _db.collection("cart");

      // Check if product already exists in cart
      final existing = await cartRef
          .where("productId", isEqualTo: product.id)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        // Increase quantity
        final doc = existing.docs.first;
        int currentQty = doc['qty'] ?? 1;

        await cartRef.doc(doc.id).update({
          "qty": currentQty + 1,
        });
      } else {
        // Add new item to cart
        await cartRef.add({
          "productId": product.id,
          "name": product.name,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "qty": 1,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("🔥 ERROR addToCart: $e");
      rethrow;
    }
  }

  // ----------------------------
  //  REMOVE FROM CART
  // ----------------------------
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _db.collection("cart").doc(cartItemId).delete();
    } catch (e) {
      print("🔥 ERROR removeFromCart: $e");
      rethrow;
    }
  }

  // ----------------------------
  //  UPDATE QTY
  // ----------------------------
  Future<void> updateQty(String cartItemId, int qty) async {
    try {
      if (qty <= 0) {
        await removeFromCart(cartItemId);
      } else {
        await _db.collection("cart").doc(cartItemId).update({
          "qty": qty,
        });
      }
    } catch (e) {
      print("🔥 ERROR updateQty: $e");
      rethrow;
    }
  }

  // ----------------------------
  //  GET CART STREAM
  // ----------------------------
  Stream<QuerySnapshot> cartStream() {
    return _db
        .collection("cart")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  // ----------------------------
  //  CLEAR CART
  // ----------------------------
  Future<void> clearCart() async {
    try {
      final items = await _db.collection("cart").get();
      for (var doc in items.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("🔥 ERROR clearCart: $e");
      rethrow;
    }
  }
}
