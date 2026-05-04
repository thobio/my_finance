import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = kIsWeb ? null : (googleSignIn ?? GoogleSignIn());

  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignIn;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map(
          (user) => user == null ? null : _mapUser(user),
        );
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    if (kIsWeb) {
      // On web use Firebase Auth popup — no separate GoogleSignIn client ID needed.
      final userCredential =
          await _auth.signInWithPopup(GoogleAuthProvider());
      final user = userCredential.user;
      if (user == null) throw const AuthCancelledException();
      return _mapUser(user);
    }

    final googleUser = await _googleSignIn!.signIn();
    if (googleUser == null) throw const AuthCancelledException();

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _mapUser(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      if (_googleSignIn != null) _googleSignIn.signOut(),
    ]);
  }

  AuthUser _mapUser(User user) => AuthUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoURL,
      );
}

class AuthCancelledException implements Exception {
  const AuthCancelledException();

  @override
  String toString() => 'Sign-in was cancelled.';
}
