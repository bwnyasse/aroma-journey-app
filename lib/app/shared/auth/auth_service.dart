import 'package:aroma_journey/app/shared/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceException implements Exception {
  final Object error;
  final String message;

  AuthServiceException(this.message, this.error);
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///
  /// User wants to sign in with Google Credentials
  ///
  Future<CurrentUser?> signInWithGoogle() async {
    CurrentUser? user;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        return getUser();
      }
    } catch (error) {
      throw AuthServiceException('signInWithGoogle error', error);
    }

    return user;
  }

  ///
  /// User wants to sign out
  ///
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  ///
  /// Check is the current user is signed in
  ///
  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null || currentUser.toString().isEmpty;
  }

  ///
  /// Retrieve the signed in User
  ///
  CurrentUser? getUser() {
    User? user = _firebaseAuth.currentUser;

    return CurrentUser(
      email: user?.email,
      displayName: user?.displayName,
      photoURL: user?.photoURL?.replaceAll("s96-c", "s300-c"),
    );
  }
}
