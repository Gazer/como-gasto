import 'package:como_gasto/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
