import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot order;

  const AdminOrderDetailPage({super.key, required this.order});

  @override
  State<AdminOrderDetailPage> createState() =>
      _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  final OrderService orderService = OrderService();
  late String status;

  @override
  void initState() {
    super.initState();

    final data = widget.order.data() as Map<String, dynamic>;
    status = data['status'] ?? 'pending';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.order.data() as Map<String, dynamic>;
    final List items = data['items'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _row('Nama', data['name'] ?? '-'),
            _row('No HP', data['phone'] ?? '-'),
            _row('Alamat', data['address'] ?? '-'),
            _row('Pembayaran', data['paymentMethod'] ?? '-'),

            const Divider(),

            const Text(
              'Produk',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...items.map(
              (item) => ListTile(
                title: Text(item['name'] ?? '-'),
                trailing: Text(
                  '${item['qty'] ?? 0} x Rp ${item['price'] ?? 0}',
                ),
              ),
            ),

            const Divider(),

            Text(
              'Total: Rp ${data['totalPrice'] ?? 0}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: status,
              decoration:
                  const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                    value: 'pending', child: Text('Pending')),
                DropdownMenuItem(
                    value: 'process', child: Text('Diproses')),
                DropdownMenuItem(
                    value: 'success', child: Text('Selesai')),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await orderService.updateOrderStatus(
                  widget.order.id,
                  status,
                );
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $value'),
    );
  }
}
