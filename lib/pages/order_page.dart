import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index];

              return ListTile(
                title: Text('Order #${data.id.substring(0, 6)}'),
                subtitle: Text('Total: Rp ${data['totalPrice']}'),
                trailing: Text(data['status']),
              );
            },
          );
        },
      ),
    );
  }
}
