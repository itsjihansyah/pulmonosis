import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static const String userId = "O0PYLoUqPt13rUkMsDT2";

  /// Ambil Calprotectin terbaru
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLatestCalprotectin() {
    return FirebaseFirestore.instance
        .collection('calprotectin')
        .where(
          'userId',
          isEqualTo: FirebaseFirestore.instance.doc('users/$userId'),
        )
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();
  }

  /// Ambil LCSS terbaru
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLatestLcss() {
    return FirebaseFirestore.instance
        .collection('surveys')
        .where(
          'userId',
          isEqualTo: FirebaseFirestore.instance.doc('users/$userId'),
        )
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();
  }

  /// Simpan hasil LCSS (answers + score + hospital rekomendasi)
  static Future<void> saveLcssResult({
    required List<int> answers,
    required double score,
    required int hospital, // 🔥 ubah dari String → int
  }) async {
    await FirebaseFirestore.instance.collection('surveys').add({
      'userId': FirebaseFirestore.instance.doc('users/$userId'),
      'answers': answers,
      'score': score,
      'hospital': hospital, // disimpan sbg int
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
