
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // ⭐️ METHODE REQUISE PAR FIREBASE (ProductService) : Convertit Map -> Product
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id, // L'ID Firestore est passé séparément
      name: map['name'] as String,
      category: map['category'] as String,
      // Firestore stocke souvent les nombres comme int ou double. On assure le double ici.
      price: (map['price'] as num).toDouble(), 
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }

  // ⭐️ METHODE REQUISE PAR FIREBASE (ProductService) : Convertit Product -> Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
    
  }
}