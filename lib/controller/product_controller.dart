// lib/controllers/product_controller.dart

import 'package:e_commerceflutter/model/product.dart';
import 'package:e_commerceflutter/services/product_service.dart';

class ProductController {
  final ProductService _service = ProductService();

  /// Stream de tous les produits (mise à jour en temps réel)
  Stream<List<Product>> getProductsStream() {
    return _service.getProductsStream();
  }

  /// Récupérer tous les produits une seule fois
  Future<List<Product>> fetchAll() {
    return _service.getProducts();
  }

  /// Ajouter un produit dans Firestore
  Future<void> add(Product product) {
    return _service.addProduct(product);
  }

  /// Modifier un produit existant
  Future<void> update(Product product) {
    return _service.updateProduct(product);
  }

  /// Supprimer un produit par ID
  Future<void> delete(String id) {
    return _service.deleteProduct(id);
  }

  /// Récupérer un produit avec son ID
  Future<Product?> getById(String id) {
    return _service.getProductById(id);
  }
}
