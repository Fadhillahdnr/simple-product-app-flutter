import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/currency_formatter.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final Function(Product)? onAddToCart;

  const ProductDetailPage({Key? key, required this.product, this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imagePath,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              CurrencyFormatter.formatRupiah(product.price),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(product.description),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (onAddToCart != null) {
                    onAddToCart!(product);
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
