// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  // 1. Lire tous les produits en stream
  Stream<List<Product>> getProductsStream() {
    return productsCollection.snapshots().map((snapshot) {
      // Résout l'erreur de type 'List<dynamic>' / 'Member not found: Product.fromMap'
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 2. Lire tous les produits en Future (méthode asynchrone)
  Future<List<Product>> getProducts() async {
    final snapshot = await productsCollection.get();

    // Résout l'erreur de type 'List<dynamic>' / 'Member not found: Product.fromMap'
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // 3. Lire un produit par son ID
  Future<Product?> getProductById(String id) async {
    final doc = await productsCollection.doc(id).get();
    if (!doc.exists) return null;

    // Résout l'erreur 'Member not found: Product.fromMap'
    return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // 4. Ajouter un produit
  Future<void> addProduct(Product product) async {
    // Résout l'erreur 'The method 'toMap' isn't defined'
    await productsCollection.add(product.toMap());
  }

  // 5. Mettre à jour un produit
  Future<void> updateProduct(Product product) async {
    // Résout l'erreur 'The method 'toMap' isn't defined'
    await productsCollection.doc(product.id).update(product.toMap());
  }

  // 6. Supprimer un produit
  Future<void> deleteProduct(String id) async {
    await productsCollection.doc(id).delete();
  }
}