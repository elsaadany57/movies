import 'package:flutter/foundation.dart';

import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'library_view_model.dart';

/// Holds the signed-in user's profile. Their watch list and history live in
/// [LibraryViewModel]; this only makes sure they are wiped when the account
/// goes away, so the next person to sign in never sees them.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository, this._library);

  final AuthRepository _repository;
  final LibraryViewModel _library;

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  Future<void> signOut() async {
    await _repository.signOut();
    _forget();
  }

  Future<bool> deleteAccount() async {
    try {
      await _repository.deleteAccount();
      _forget();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _forget() {
    _user = null;
    _library.clear();
  }
}
