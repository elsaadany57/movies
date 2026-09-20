import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Single source of truth for the signed-in user. ViewModels talk to this,
/// never to Firebase directly.
class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  bool get isSignedIn => _service.currentUser != null;

  Future<AppUser?> login(String email, String password) async {
    final credential = await _service.signIn(email, password);
    final uid = credential.user!.uid;
    return _service.fetchProfile(uid);
  }

  /// Creates the account, then writes the profile fields Auth cannot hold.
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatar,
  }) async {
    final credential = await _service.createAccount(email, password);
    final user = AppUser(
      uid: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
    );
    await _service.saveProfile(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) {
    return _service.sendPasswordReset(email);
  }

  Future<void> signOut() => _service.signOut();
}
