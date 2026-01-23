import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/order_service.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartService cartService = CartService();
  final OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    final List<Product> items = cartService.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? const Center(child: Text('Keranjang masih kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];

                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image),
                        ),
                        title: Text(product.name),
                        subtitle: Text('Rp ${product.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartService.removeFromCart(product);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => CartPage()),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // ================= TOTAL + CHECKOUT =================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total: Rp ${cartService.totalPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text('Checkout'),
                          onPressed: () async {
                            final user =
                                FirebaseAuth.instance.currentUser;

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Silakan login kembali'),
                                ),
                              );
                              return;
                            }

                            try {
                              await orderService.createOrder(
                                userId: user.uid,
                                totalPrice: cartService.totalPrice,
                              );

                              cartService.clearCart();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Pesanan berhasil dibuat'),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Gagal checkout: $e'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
