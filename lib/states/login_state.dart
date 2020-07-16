import 'package:como_gasto/auth_providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  FirebaseAuth _auth;
  AuthenticationProvider _authenticationProvider;
  AuthenticationProviderFactory _authenticationProviderFactory;

  SharedPreferences _prefs;

  bool _loggedIn = false;
  bool _loading = true;

  FirebaseUser _user;

  LoginState({
    @required SharedPreferences preferences,
    @required FirebaseAuth firebaseAuth,
    AuthenticationProviderFactory authenticationProviderFactory =
        const AuthenticationProviderFactory(),
  }) {
    _prefs = preferences;
    _auth = firebaseAuth;
    _authenticationProviderFactory = authenticationProviderFactory;
    loginState();
  }

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  FirebaseUser currentUser() => _user;

  Future<void> login(LoginProvider loginProvider) async {
    _authenticationProvider =
        _authenticationProviderFactory.createAuthProvider(loginProvider);

    _loading = true;
    notifyListeners();

    var authCredentials = await _authenticationProvider.handleSignIn();

    if (authCredentials != null) {
      var authResult = await _auth.signInWithCredential(authCredentials);
      if (authResult != null) {
        _user = authResult.user;
      }
      if (_user != null) {
        print("signed in " + _user.displayName);
      }
    }

    _loading = false;
    _loggedIn = _user != null;
    _prefs.setBool('isLoggedIn', _loggedIn);
    notifyListeners();
  }

  void logout() {
    _prefs.clear();
    if (_authenticationProvider != null) {
      _authenticationProvider.logout();
      _authenticationProvider = null;
    }
    _auth.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  void loginState() async {
    if (_prefs.containsKey('isLoggedIn')) {
      _user = await _auth.currentUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}
