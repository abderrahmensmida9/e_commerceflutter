// lib/model/product.dart

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // ✅ category est bien là

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  /// Convert Firestore → Product (Utilisé pour récupérer les données)
  factory Product.fromMap(String id, Map<String, dynamic> map) { // ✅ Cette méthode doit exister
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['image'] ?? '',
      category: map['category'] ?? '',
    );
  }

  /// Convert Product → Firestore (Utilisé pour sauvegarder les données)
  Map<String, dynamic> toMap() { // ✅ Cette méthode doit exister
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': imageUrl,
      'category': category,
    };
  }
}