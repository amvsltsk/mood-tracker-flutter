import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../repositories/mood_repository.dart';

class MoodProvider extends ChangeNotifier {
  final MoodRepository _repository;

  List<MoodEntry> _moods = [];
  bool _isLoading = false;
  String? _error;

  StreamSubscription<List<MoodEntry>>? _moodsSub;

  MoodProvider(this._repository);

  List<MoodEntry> get moods => _moods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Одноразове завантаження (History screen)
  Future<void> loadMoods(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _moods = await _repository.getAllMoods(userId);
    } catch (e) {
      _error = e.toString();
      _moods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Реальний час
  void watchMoods(String userId) {
    _moodsSub?.cancel();

    _moodsSub = _repository.watchMoods(userId).listen(
          (data) {
        _moods = data;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> addMood(MoodEntry mood) async {
    await _repository.addMood(mood);
    if (_moodsSub == null) {
      _moods.insert(0, mood);
      notifyListeners();
    }
  }

  Future<void> updateMood(MoodEntry mood) async {
    await _repository.updateMood(mood);
    final index = _moods.indexWhere((m) => m.id == mood.id);
    if (index != -1) {
      _moods[index] = mood;
      notifyListeners();
    }
  }

  Future<void> deleteMood(String moodId) async {
    await _repository.deleteMood(moodId);
    _moods.removeWhere((m) => m.id == moodId);
    notifyListeners();
  }

  /// Фільтрація (для History)
  List<MoodEntry> filterMoods({
    DateTimeRange? dateRange,
    String? mood,
  }) {
    var result = _moods;

    if (dateRange != null) {
      final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
      final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);

      result = result.where((m) {
        final d = DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
        return !d.isBefore(start) && !d.isAfter(end);
      }).toList();
    }

    if (mood != null) {
      result = result.where((m) => m.mood == mood).toList();
    }

    return result;
  }

  void clear() {
    _moodsSub?.cancel();
    _moodsSub = null;
    _moods = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _moodsSub?.cancel();
    super.dispose();
  }
}
