import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../model/product.dart';
import '../model/cart_item.dart';

// Définition du StateNotifierProvider
final cartProvider = StateNotifierProvider<CartController, List<CartItem>>((ref) {
  return CartController();
});

// Classe qui gère le panier
class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state[index].quantity++;
      state = [...state]; // pour notifier le changement
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice =>
      state.fold(0, (total, item) => total + item.product.price * item.quantity);
}
