import 'package:como_gasto/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/notifications/local_notifications.dart';

final GetIt _l = GetIt.instance;

Future<void> init() async {
  _l.registerFactory<FirebaseAuth>(() => FirebaseAuth.instance);

  var sharedPreferences = await SharedPreferences.getInstance();
  _l.registerSingleton(sharedPreferences);

  _l.registerLazySingleton(
    () => LoginState(
      preferences: _l(),
      firebaseAuth: _l(),
    ),
  );

  if (kIsWeb) {
    _l.registerSingleton<LocalNotifications>(WebLocalNotifications());
  } else {
    _l.registerSingleton<LocalNotifications>(MobileLocalNotifications());
  }
}
