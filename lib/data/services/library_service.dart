import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';

/// Reads and writes the signed-in user's watch list and history, which live
/// under `users/{uid}/` so each account only ever sees its own.
class LibraryService {
  LibraryService(this._auth, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final AuthService _auth;
  final FirebaseFirestore _firestore;

  static const watchList = 'watchlist';
  static const history = 'history';

  /// Most recent entries shown; older ones stay stored but are not fetched.
  static const _fetchLimit = 100;

  /// Null when nobody is signed in, in which case every call is a no-op.
  CollectionReference<Map<String, dynamic>>? _collection(String name) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection(name);
  }

  Future<List<Map<String, dynamic>>> fetch(String name) async {
    final collection = _collection(name);
    if (collection == null) return const [];

    final snapshot = await collection
        .orderBy('addedAt', descending: true)
        .limit(_fetchLimit)
        .get();
    return [for (final doc in snapshot.docs) doc.data()];
  }

  /// Keyed by movie id, so adding the same movie again just refreshes its
  /// timestamp and moves it to the top instead of duplicating it.
  Future<void> add(String name, Map<String, dynamic> movie) async {
    await _collection(name)?.doc('${movie['id']}').set({
      ...movie,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> remove(String name, int movieId) async {
    await _collection(name)?.doc('$movieId').delete();
  }
}
