import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static bool loggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static String currentMail() {
    return FirebaseAuth.instance.currentUser!.email.toString();
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
