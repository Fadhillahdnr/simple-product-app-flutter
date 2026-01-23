import 'package:flutter/material.dart';
import '../services/cart_service.dart';


class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final cartItems = cartService.cartItems;
    final totalPrice = cartService.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Tidak ada produk untuk checkout'),
            )
          : Column(
              children: [
                // LIST PRODUK
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.asset(
                          product.imageUrl,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(product.name),
                        subtitle: Text('Rp ${product.price}'),
                      );
                    },
                  ),
                ),

                // TOTAL & BUTTON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: const Border(
                      top: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp $totalPrice',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text('Bayar Sekarang'),
                          onPressed: () {
                            cartService.clearCart();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout berhasil 🎉'),
                              ),
                            );

                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
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
