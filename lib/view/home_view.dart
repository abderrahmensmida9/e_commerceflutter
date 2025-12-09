// lib/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:e_commerceflutter/controller/product_controller.dart';
import 'package:e_commerceflutter/model/product.dart';
import 'product_detail_view.dart';
// ⚠️ ASSUREZ-VOUS D'IMPORTER LA PAGE DU PANIER QUE NOUS VENONS DE CRÉER
import 'cart_view.dart'; 

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductController _controller = ProductController();
  String _selectedCategory = "Tous";

  final List<String> categories = [
    "Tous",
    "Ordinateurs",
    "Audio",
    "Smartphones",
    "Montres",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ▬▬▬▬▬▬▬▬▬▬ HEADER ▬▬▬▬▬▬▬▬▬▬▬
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A4DFD), Color(0xFF9A68FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu, color: Colors.white, size: 26),
                      const SizedBox(width: 12),
                      const Text("SUP4 DEV",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),

                      // ⭐️ NOUVEAU : Icône du panier dynamique
                      _buildCartIconWithBadge(context), 
                      
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications_outlined,
                          color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Search bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Rechercher...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ▬▬▬▬▬▬▬▬▬▬ CATEGORIES ▬▬▬▬▬▬▬▬▬▬▬
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];
                  final isSelected = c == _selectedCategory;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        c,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ▬▬▬▬▬▬▬▬▬▬ LISTE DES PRODUITS ▬▬▬▬▬▬▬▬▬▬▬
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _controller.getProductsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Product> products = snapshot.data!;

                  // Filtre catégorie
                  if (_selectedCategory != "Tous") {
                    products = products
                        .where((p) =>
                            p.category.toLowerCase() ==
                            _selectedCategory.toLowerCase())
                        .toList();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: .65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, i) {
                      final p = products[i];
                      return _buildProductCard(context, p);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // ⭐️ NOUVELLE MÉTHODE : Widget pour le badge du panier et navigation
  Widget _buildCartIconWithBadge(BuildContext context) {
    return StreamBuilder<List<Product>>(
      // Écouter le stream du panier
      stream: _controller.cartStream,
      initialData: const [], 
      builder: (context, snapshot) {
        final itemCount = snapshot.data?.length ?? 0;
        
        return GestureDetector(
          onTap: () {
            // ✅ Navigation vers la CartView au clic sur l'icône
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => CartView())
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  color: Colors.white),

              // Afficher le badge uniquement si des articles sont présents
              if (itemCount > 0)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5)
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        itemCount > 99 ? '99+' : itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }


  // ▬▬▬▬▬▬▬▬▬▬ CARD PRODUIT ▬▬▬▬▬▬▬▬▬▬▬
  Widget _buildProductCard(BuildContext context, Product p) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => ProductDetailView(product: p))),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                p.imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                p.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${p.price.toStringAsFixed(2)} €",
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A4DFD), // Couleur de l'en-tête
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text("Ajouter"),
                  onPressed: () {
                    // ✅ Logique d'ajout au panier (via le contrôleur)
                    _controller.addToCart(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${p.name} ajouté au panier !"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}