import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String TWITTER_API = "...";
final String TWITTER_SECRET = "...";

enum LoginProvider {
  GOOGLE,
  TWITTER,
  FACEBOOK,
}

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;

  // TODO: Set twitter credentials and uncomment logic
  // Also uncomment the dependency on the pubspec.yaml file
  //  final TwitterLogin _twitterLogin = TwitterLogin(
  //    consumerKey: TWITTER_API,
  //    consumerSecret: TWITTER_SECRET,
  //  );

  bool _loggedIn = false;
  bool _loading = true;
  FirebaseUser _user;

  LoginState() {
    loginState();
  }

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  FirebaseUser currentUser() => _user;

  void login(LoginProvider loginProvider) async {
    _loading = true;
    notifyListeners();

    switch (loginProvider) {
      case LoginProvider.GOOGLE:
        _user = await _handleSignIn();
        break;
      case LoginProvider.TWITTER:
        _user = await _handleTwitterSignIn();
        break;
      case LoginProvider.FACEBOOK:
        _user = await _handleFacebookSignIn();
        break;
    }

    _loading = false;
    _loggedIn = _user != null;
    _prefs.setBool('isLoggedIn', _loggedIn);
    notifyListeners();
  }

  void logout() {
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  // TODO: Set twitter credentials and uncomment logic
  // Also uncomment the dependency on the pubspec.yaml file
  Future<FirebaseUser> _handleFacebookSignIn() async {
    //    final facebookLogin = FacebookLogin();
    //    final result = await facebookLogin.logIn(['email']);
    //    if (result.status != FacebookLoginStatus.loggedIn) {
    //      return null;
    //    }
    //
    //    final AuthCredential credential = FacebookAuthProvider.getCredential(
    //      accessToken: result.accessToken.token,
    //    );
    //
    //    final FirebaseUser user = await _auth.signInWithCredential(credential);
    //    print("signed in " + user.displayName);
    //    return user;
    return null;
  }

  Future<FirebaseUser> _handleTwitterSignIn() async {
    //    var twitterResult = await _twitterLogin.authorize();
    //    if (twitterResult.status != TwitterLoginStatus.loggedIn) {
    //      return null;
    //    }
    //
    //    var session = twitterResult.session;
    //
    //    final AuthCredential credential = TwitterAuthProvider.getCredential(
    //      authToken: session.token,
    //      authTokenSecret: session.secret,
    //    );
    //
    //    final FirebaseUser user = await _auth.signInWithCredential(credential);
    //    print("signed in " + user.displayName);
    //    return user;
    return null;
  }

  Future<FirebaseUser> _handleSignIn() async {
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

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
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
