import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';
import 'home_admin_page.dart';
import 'home_user_page.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔐 Ambil role dari Firestore
  Future<String> _getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      debugPrint('USER DOC TIDAK DITEMUKAN');
      return 'user'; // default aman
    }

    final role = doc.data()?['role'];
    debugPrint('LOGIN ROLE: $role');

    return role ?? 'user';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, authSnapshot) {

        // ⏳ Menunggu status auth
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Belum login
        if (!authSnapshot.hasData) {
          return const LoginPage();
        }

        final user = authSnapshot.data!;

        // 🔍 Ambil role user
        return FutureBuilder<String>(
          future: _getUserRole(user.uid),
          builder: (context, roleSnapshot) {

            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data ?? 'user';

            // ✅ Routing berdasarkan role
            if (role == 'admin') {
              return AdminHomePage();
            } else {
              return UserHomePage();
            }
          },
        );
      },
    );
  }
}
