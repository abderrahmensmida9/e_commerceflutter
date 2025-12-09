// lib/views/cart_view.dart
import 'package:flutter/material.dart';
import 'package:e_commerceflutter/controller/product_controller.dart';
import 'package:e_commerceflutter/model/product.dart';

class CartView extends StatelessWidget {
  final ProductController _controller = ProductController();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
        backgroundColor: const Color(0xFF6A4DFD),
        foregroundColor: Colors.white,
      ),
      
      body: StreamBuilder<List<Product>>(
        stream: _controller.cartStream,
        initialData: const [],
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return const Center(
              child: Text("Votre panier est vide.", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
          
          final double subtotal = cartItems.fold(0.0, (sum, item) => sum + item.price);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    return _buildCartItem(context, product);
                  },
                ),
              ),

              // ▬▬▬▬▬▬▬▬▬▬ BAS DE PAGE (RÉSUMÉ ET BOUTON) ▬▬▬▬▬▬▬▬▬▬
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(0, -2))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sous-total :', style: TextStyle(fontSize: 16)),
                        Text(
                          '${subtotal.toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // ⭐️ LOGIQUE DE CHECKOUT ⭐️
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Traitement de la commande..."), duration: Duration(seconds: 1)),
                          );
                          
                          await _controller.checkout(); 
                          
                          if (context.mounted) {
                              Navigator.pop(context); 
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("🎉 Commande passée avec succès !"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Procéder au paiement', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget pour afficher un article du panier
  Widget _buildCartItem(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image et Détails du produit...
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(product.imageUrl, height: 60, width: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${product.price.toStringAsFixed(2)} €', style: const TextStyle(color: Color(0xFF6A4DFD), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            
            // Bouton de suppression
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // ✅ Appel de la méthode de suppression (qui supprime de Firestore)
                _controller.removeFromCart(product); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} retiré."), duration: const Duration(milliseconds: 800)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}