import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';

/// Drives all three auth screens. Each action shares the same loading and
/// error handling, so the screens only decide what to run and where to go.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  bool _isLoading = false;
  String? _error;
  AppUser? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AppUser? get user => _user;

  Future<bool> login(String email, String password) {
    return _run(() async {
      _user = await _repository.login(email, password);
    });
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatar,
  }) {
    return _run(() async {
      _user = await _repository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatar: avatar,
      );
    });
  }

  Future<bool> sendPasswordReset(String email) {
    return _run(() => _repository.sendPasswordReset(email));
  }

  /// Runs [action] with the shared loading/error cycle. Returns whether it
  /// succeeded, so the caller can navigate only on success.
  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _messageFor(e);
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static String _messageFor(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'That email address is not valid.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
        'Wrong email or password.',
      'email-already-in-use' => 'That email already has an account.',
      'weak-password' => 'Pick a stronger password.',
      'network-request-failed' => 'No internet connection.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'operation-not-allowed' =>
        'Email sign-in is switched off for this project.',
      _ => e.message ?? 'Something went wrong. Please try again.',
    };
  }
}
