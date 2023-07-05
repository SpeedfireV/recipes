import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      debugPrint(gUser.toString());

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      debugPrint(gUser.toString());
      return null;
    }
  }

  //TODO: Facebook

  //TODO: Apple

  //TODO: Twitter
}