import 'package:flutter/foundation.dart';

import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';

/// Holds the signed-in user's profile and the two lists the profile tabs
/// show. The lists are local for now; nothing persists them yet.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository);

  final AuthRepository _repository;

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // TODO: persist these once the watchlist has a home in Firestore.
  final List<int> watchList = [];
  final List<int> history = [];

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repository.currentProfile();
    } catch (_) {
      _error = 'Could not load your profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required int avatar,
  }) async {
    final user = _user;
    if (user == null) return false;

    final updated = AppUser(
      uid: user.uid,
      name: name,
      email: user.email,
      phone: phone,
      avatar: avatar,
    );

    try {
      await _repository.updateProfile(updated);
      _user = updated;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() => _repository.signOut();

  Future<bool> deleteAccount() async {
    try {
      await _repository.deleteAccount();
      _user = null;
      return true;
    } catch (_) {
      return false;
    }
  }
}
