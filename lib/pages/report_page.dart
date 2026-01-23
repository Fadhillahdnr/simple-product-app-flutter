import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: FutureBuilder(
        future: Future.wait([
          FirebaseFirestore.instance.collection('products').get(),
          FirebaseFirestore.instance.collection('orders').get(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data![0].docs.length;
          final orders = snapshot.data![1].docs.length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total Produk'),
                    trailing: Text(products.toString()),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Total Pesanan'),
                    trailing: Text(orders.toString()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
