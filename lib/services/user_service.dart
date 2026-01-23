import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      return 'user'; // default
    }

    return doc.data()?['role'] ?? 'user';
  }
}
