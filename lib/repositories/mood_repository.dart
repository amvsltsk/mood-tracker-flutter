import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry.dart';

class MoodRepository {
  final _db = FirebaseFirestore.instance;
  final _collection = 'moods';

  /// Створити запис
  Future<void> addMood(MoodEntry mood) async {
    if (mood.id.isEmpty) {
      final docRef = await _db.collection(_collection).add(mood.toMap());
      mood.id = docRef.id;
    } else {
      await _db.collection(_collection).doc(mood.id).set(mood.toMap());
    }
  }

  /// Отримати всі записи користувача
  Future<List<MoodEntry>> getAllMoods(String userId) async {
    final query = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();
    return query.docs
        .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Потік у реальному часі
  Stream<List<MoodEntry>> watchMoods(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
        .toList());
  }

  /// Оновити
  Future<void> updateMood(MoodEntry mood) async {
    await _db.collection(_collection).doc(mood.id).update(mood.toMap());
  }

  /// Видалити
  Future<void> deleteMood(String moodId) async {
    await _db.collection(_collection).doc(moodId).delete();
  }
}
