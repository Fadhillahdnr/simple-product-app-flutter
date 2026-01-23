import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_product_page.dart';
import 'manage_product_page.dart';
import 'order_page.dart';
import 'report_page.dart';
import '../services/product_service.dart';
import 'admin_orders_page.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ✅ AuthWrapper otomatis balik ke LoginPage
              },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _DashboardCard(
              icon: Icons.add_box,
              title: 'Tambah Produk',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.inventory,
              title: 'Kelola Produk',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManageProductPage()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.receipt_long,
              title: 'Pesanan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminOrdersPage()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.analytics,
              title: 'Laporan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
