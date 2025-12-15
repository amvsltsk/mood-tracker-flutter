import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  String id;
  final String userId;
  final DateTime timestamp;
  final String mood;
  final String? comment;

  MoodEntry({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mood,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'mood': mood,
      'comment': comment,
    };
  }

  factory MoodEntry.fromMap(String id, Map<String, dynamic> map) {
    // Normalize timestamp which may come as a Firestore Timestamp, a String, or a DateTime
    final dynamic ts = map['timestamp'];
    DateTime timestamp;
    if (ts is Timestamp) {
      timestamp = ts.toDate();
    } else if (ts is DateTime) {
      timestamp = ts;
    } else if (ts is String) {
      timestamp = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      timestamp = DateTime.now();
    }

    return MoodEntry(
      id: id,
      userId: map['userId'] ?? '',
      timestamp: timestamp,
      mood: map['mood'] ?? '',
      comment: map['comment'] as String?,
    );
  }

  MoodEntry copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    String? mood,
    String? comment,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      mood: mood ?? this.mood,
      comment: comment ?? this.comment,
    );
  }
}
