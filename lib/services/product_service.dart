// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  // Déclarations des collections
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
      
  final CollectionReference cartItemsCollection =
      FirebaseFirestore.instance.collection('cartItems');

  // Jeu de données initial pour peupler le catalogue
  final List<Product> _initialProductsData = [
    Product(
      id: '',
      name: 'Portable Ultra-léger Pro',
      category: 'Ordinateurs',
      price: 1399.99,
      imageUrl: 'https://images.unsplash.com/photo-1629131666358-39b8c04d16d1?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: 'Ordinateur portable de haute performance et design.',
    ),
    Product(
      id: '',
      name: 'Écouteurs sans fil AirWave Pro',
      category: 'Audio',
      price: 149.50,
      imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e911bf0ba9?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: 'Qualité de son supérieure avec réduction de bruit.',
    ),
    Product(
      id: '',
      name: 'Montre connectée FitGear',
      category: 'Montres',
      price: 249.99,
      imageUrl: 'https://images.unsplash.com/photo-1546868871-bc0bd5b4936b?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description: 'Suivi de la santé et autonomie longue durée.',
    ),
  ];


  // ▬▬▬▬▬▬▬▬▬▬ CATALOGUE (LECTURE / INITIALISATION) ▬▬▬▬▬▬▬▬▬▬

  Future<List<Product>> getProducts() async {
    final snapshot = await productsCollection.get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
  
  Stream<List<Product>> getProductsStream() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Initialise le catalogue s'il est vide
  Future<void> initializeProducts() async {
    final snapshot = await productsCollection.get();
    if (snapshot.docs.isNotEmpty) return;
    
    final batch = FirebaseFirestore.instance.batch();
    for (var product in _initialProductsData) {
      final docRef = productsCollection.doc(); 
      batch.set(docRef, product.toMap());
    }
    await batch.commit();
  }
  
  // ▬▬▬▬▬▬▬▬▬▬ PANIER (CRUD) ▬▬▬▬▬▬▬▬▬▬
  
  Stream<List<Product>> getCartStream() {
    return cartItemsCollection
        .orderBy('addedAt', descending: true) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // L'ID du document Firestore est utilisé comme Product.id du panier
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap(doc.id, data); 
      }).toList();
    });
  }

  Future<void> addToCart(Product product) async {
    final itemData = product.toMap();
    itemData['quantity'] = 1; 
    itemData['addedAt'] = FieldValue.serverTimestamp(); 
    await cartItemsCollection.add(itemData);
  }

  Future<void> removeFromCart(String cartDocumentId) async {
    await cartItemsCollection.doc(cartDocumentId).delete();
  }

  // Vider le panier après une commande
  Future<void> clearCart() async {
    final snapshot = await cartItemsCollection.get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}