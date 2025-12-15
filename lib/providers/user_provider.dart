import 'dart:async';

import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository;

  UserProfile? _user;
  bool _isLoading = false;
  String? _error;

  StreamSubscription<UserProfile?>? _userSub;

  UserProvider(this._repository);

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Одноразове завантаження
  Future<void> loadUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repository.getUser(userId);
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Підписка на реальний час
  void watchUser(String userId) {
    _userSub?.cancel();

    _userSub = _repository.watchUser(userId).listen(
          (updatedUser) {
        _user = updatedUser;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> updateUser(UserProfile updatedUser) async {
    await _repository.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> createUser(UserProfile user) async {
    await _repository.createUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    await _repository.deleteUser(userId);
    _user = null;
    notifyListeners();
  }

  void clear() {
    _userSub?.cancel(); // ⬅️ критично
    _userSub = null;
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}