import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final ProductService productService = ProductService();

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    imageCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Harga
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Deskripsi
              TextFormField(
                controller: descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Produk',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Image URL / Image Name
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama / URL Gambar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gambar wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Button Simpan
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final product = Product(
                      id: '',
                      name: nameCtrl.text.trim(),
                      price: double.parse(priceCtrl.text),
                      description: descriptionCtrl.text.trim(),
                      imageUrl: 'assets/images/${imageCtrl.text.trim()}',
                    );

                    await productService.addProduct(product);

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Simpan Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
