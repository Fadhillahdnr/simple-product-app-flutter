import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return const Center(
              child: Text('Terjadi kesalahan saat memuat data'),
            );
          }

          // ❌ Data kosong
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Data pesanan tidak ditemukan'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final List items = data['items'] ?? [];
          final String status = data['status'] ?? '-';
          final Timestamp? createdAt = data['createdAt'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================
                // INFO PESANAN
                // =====================
                _infoRow('Order ID', orderId),
                _infoRow('Status', status),
                _infoRow(
                  'Tanggal',
                  createdAt != null
                      ? DateFormat('dd MMM yyyy, HH:mm')
                          .format(createdAt.toDate())
                      : '-',
                ),

                const SizedBox(height: 20),
                const Divider(),

                // =====================
                // LIST PRODUK
                // =====================
                const Text(
                  'Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (items.isEmpty)
                  const Text('Tidak ada item')
                else
                  Column(
                    children: items.map<Widget>((item) {
                      final int price = (item['price'] ?? 0) as int;
                      final int qty = (item['quantity'] ?? 1) as int;
                      final int subtotal = price * qty;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Image.network(
                            item['imageUrl'] ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(item['name'] ?? '-'),
                          subtitle: Text('Rp $price x $qty'),
                          trailing: Text(
                            'Rp $subtotal',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 20),
                const Divider(),

                // =====================
                // TOTAL
                // =====================
                _buildTotal(items),
              ],
            ),
          );
        },
      ),
    );
  }

  // =====================
  // WIDGET INFO
  // =====================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // =====================
  // HITUNG TOTAL
  // =====================
  Widget _buildTotal(List items) {
    int total = 0;

    for (var item in items) {
      final int price = (item['price'] ?? 0) as int;
      final int qty = (item['quantity'] ?? 1) as int;
      total += price * qty;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Rp $total',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
