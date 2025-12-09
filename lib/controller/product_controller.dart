// lib/controller/product_controller.dart

import 'dart:async';
import '../model/product.dart';
import '../services/product_service.dart';

class ProductController {
  // Supposons que votre ProductService est initialisé ici
  final ProductService _service = ProductService();

  // ✅ CORRECTION : Définissez la méthode 'productsStream' exactement comme elle est appelée dans la vue
  Stream<List<Product>> getProductsStream() {
    // Cette méthode appelle la méthode correspondante dans le ProductService
    return _service.getProductsStream(); 
  }
  
  // (Laissez les autres méthodes ici : getProducts, getProductById, etc.)
  Future<List<Product>> getProducts() {
    return _service.getProducts(); 
  }
}