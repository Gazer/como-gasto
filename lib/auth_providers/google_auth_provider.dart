
import 'package:como_gasto/auth_providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthenticationProvider implements AuthenticationProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthCredential> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return credential;
  }

  @override
  void logout() {
    _googleSignIn.signOut();
  }
}