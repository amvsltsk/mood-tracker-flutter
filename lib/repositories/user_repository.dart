import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  final _collection = "users";

  Future<void> createUser(UserProfile user) async {
    await _db.collection(_collection).doc(user.id).set(user.toMap());
  }

  Future<UserProfile?> getUser(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.id, doc.data()!);
  }

  Future<void> updateUser(UserProfile user) async {
    await _db.collection(_collection).doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Stream<UserProfile?> watchUser(String id) {
    return _db.collection(_collection).doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.id, doc.data()!);
    });
  }
}
