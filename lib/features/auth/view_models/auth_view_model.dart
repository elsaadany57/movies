import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/app_user.dart';
import '../models/auth_failure.dart';
import '../../../data/repositories/auth_repository.dart';

/// Drives all three auth screens. Each action shares the same loading and
/// error handling, so the screens only decide what to run and where to go.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  bool _isLoading = false;
  AuthFailure? _failure;
  AppUser? _user;

  bool get isLoading => _isLoading;
  AuthFailure? get failure => _failure;
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
    _failure = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _failure = AuthFailure.fromException(e);
      if (_failure == AuthFailure.unknown) {
        debugPrint('Unmapped auth error ${e.code}: ${e.message}');
      }
      return false;
    } catch (_) {
      _failure = AuthFailure.unknown;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
