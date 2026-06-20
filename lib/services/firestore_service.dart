import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setProfile(String userId, Map<String, dynamic> data) async {
    await _db.collection('profiles').doc(userId).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _db.collection('profiles').doc(userId).get();
    return doc.data();
  }

  Future<void> updateProfileField(String userId, String field, dynamic value) async {
    await _db.collection('profiles').doc(userId).update({field: value});
  }

  Future<void> addTransaction(String userId, Map<String, dynamic> data) async {
    await _db.collection('transactions').add({
      'user_id': userId,
      ...data,
    });
  }

  Future<void> updateTransaction(String txId, Map<String, dynamic> data) async {
    await _db.collection('transactions').doc(txId).update(data);
  }

  Future<void> deleteTransaction(String txId) async {
    await _db.collection('transactions').doc(txId).delete();
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
    final snapshot = await _db
        .collection('transactions')
        .where('user_id', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }
}
