import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports/services/firebase.dart';

class AuthService {
  static bool loggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static String? currentMail() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email.toString();
    }
    return null;
  }

  static String? currentUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }
    return null;
  }

  static Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Basic
  static Future registerUser(String login, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: login.trim(), password: password.trim())
        .then((value) async {
      await FirestoreServices().createNewProfile();
    });
  }

  static Future loginUser(String login, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.trim(), password: password.trim());
  }

  // Google
  static Future signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }
  }
}
