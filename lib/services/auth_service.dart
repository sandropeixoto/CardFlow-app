import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retorna o usuário atual ou null
  User? get currentUser => _auth.currentUser;

  // Stream para ouvir mudanças de estado (Login/Logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Função de Login com Google
  Future<User?> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        // Use signInWithPopup for web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // Use signIn for mobile
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null; // User cancelled the sign-in
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      final User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _firestore.collection('users').doc(user.uid).set({
            'display_name': user.displayName,
            'email': user.email,
            'photo_url': user.photoURL,
            'created_at': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print('Erro no login Google: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Desconecta da conta Google localmente
    await _auth.signOut();         // Desloga do Firebase
  }
}
