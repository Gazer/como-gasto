
import 'package:como_gasto/auth_providers/google_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginProvider {
  GOOGLE,
  TWITTER,
  FACEBOOK,
}

class AuthenticationProviderFactory {
  const AuthenticationProviderFactory();

  AuthenticationProvider createAuthProvider(LoginProvider provider) {
    switch (provider) {
      case LoginProvider.GOOGLE:
        return GoogleAuthenticationProvider();
        break;
      case LoginProvider.TWITTER:
      // TODO: Handle this case.
        break;
      case LoginProvider.FACEBOOK:
      // TODO: Handle this case.
        break;
    }
    return null;
  }
}

abstract class AuthenticationProvider {
  Future<AuthCredential> handleSignIn();
  void logout();
}
