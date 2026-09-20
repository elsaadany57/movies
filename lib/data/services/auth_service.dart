import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

/// Talks to Firebase Auth and the `users` collection. Raw calls only — the
/// repository decides how they combine.
class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const _usersCollection = 'users';

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createAccount(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> saveProfile(AppUser user) {
    return _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<AppUser?> fetchProfile(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    final data = doc.data();
    return data == null ? null : AppUser.fromJson(data);
  }
}
