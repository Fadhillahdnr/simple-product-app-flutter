import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class ManageProductPage extends StatelessWidget {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Produk')),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: Image.network(
                  product.imageUrl,
                  width: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
                title: Text(product.name),
                subtitle: Text('Rp ${product.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    productService.deleteProduct(product.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
