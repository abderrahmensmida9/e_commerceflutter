// lib/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Contient Provider et ChangeNotifierProvider
import 'package:firebase_auth/firebase_auth.dart'; 

import '../controller/auth_controller.dart'; 
import '../controller/cart_controller.dart';
import '../controller/order_controller.dart'; 

// 1. Fournisseur AuthController (Simple Provider)
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(FirebaseAuth.instance);
});


// 2. Fournisseur CartController (ChangeNotifierProvider)



// 3. Fournisseur OrderController (ChangeNotifierProvider)
final orderProvider = ChangeNotifierProvider<OrderController>((ref) {
  
  // Lecture du simple Provider (pas de .notifier)
  final authController = ref.watch(authControllerProvider); 

  // Lecture du ChangeNotifierProvider (utilise .notifier)
  final cartController = ref.watch(cartProvider.notifier); 

  return OrderController(
    auth: authController,
    cartController: cartController,
  );
});