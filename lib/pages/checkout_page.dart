import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/order_service.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';


class CheckoutPage extends StatefulWidget {
  final List<Product> cartItems;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _paymentMethod = 'COD';

  final OrderService orderService = OrderService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Data Pengiriman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildInput(_nameController, 'Nama Pemesan'),
              const SizedBox(height: 12),
              _buildInput(_phoneController, 'No Handphone',
                  keyboard: TextInputType.phone),
              const SizedBox(height: 12),
              _buildInput(_addressController, 'Alamat Lengkap', maxLines: 3),

              const SizedBox(height: 24),

              const Text(
                'Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...widget.cartItems.map(
                (product) => ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Qty: ${product.quantity} • Rp ${product.price * product.quantity}',
                  ),
                ),
              ),

              const Divider(),

              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(value: 'COD', child: Text('COD')),
                  DropdownMenuItem(
                      value: 'Transfer', child: Text('Transfer Bank')),
                  DropdownMenuItem(
                      value: 'E-Wallet', child: Text('E-Wallet')),
                ],
                onChanged: (v) => setState(() => _paymentMethod = v!),
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 24),

              Text(
                'Total: Rp ${widget.totalPrice}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  child: const Text('Buat Pesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController c, String label,
      {int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v == null || v.isEmpty ? '$label wajib diisi' : null,
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await orderService.createOrder(
      userId: user.uid,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      paymentMethod: _paymentMethod,
      items: widget.cartItems,
      totalPrice: widget.totalPrice,
    );

    // 🧹 CLEAR CART
    context.read<CartProvider>().clearCart();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesanan berhasil dibuat')),
    );

    // 🚀 BALIK KE HOME
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }
}
