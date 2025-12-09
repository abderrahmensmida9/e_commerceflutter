// lib/controller/product_controller.dart
import 'dart:async';
import '../model/product.dart';
import '../services/product_service.dart';

class ProductController {
  final ProductService _service = ProductService();

  // ▬▬▬▬▬▬▬▬▬▬ VUE CATALOGUE ▬▬▬▬▬▬▬▬▬▬
  
  Future<List<Product>> getProducts() {
    return _service.getProducts(); 
  }
  
  Stream<List<Product>> getProductsStream() {
    return _service.getProductsStream(); 
  }

  // ▬▬▬▬▬▬▬▬▬▬ VUE PANIER ▬▬▬▬▬▬▬▬▬▬

  Stream<List<Product>> get cartStream => _service.getCartStream(); 

  void addToCart(Product product) {
    _service.addToCart(product);
  }

  void removeFromCart(Product product) {
    // Product.id est l'ID du document Firestore du panier
    _service.removeFromCart(product.id);
  }

  // Finalisation de la commande : enregistre la commande puis vide le panier
  Future<void> checkout() async {
    try {
      // 1. Logique d'enregistrement de la commande (À implémenter si nécessaire)
      // Par exemple : _service.saveOrder(orderData);
      
      // 2. Vider le panier dans Firestore
      await _service.clearCart();
      print("Panier vidé après paiement.");
      
    } catch (e) {
      print("Erreur lors du paiement: $e");
    }
  }
}