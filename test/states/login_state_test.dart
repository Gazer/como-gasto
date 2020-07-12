import 'dart:math';

import 'package:como_gasto/auth_providers/auth_provider.dart';
import 'package:como_gasto/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// class MockAuthenticationProviderFactory extends Mock
//     implements AuthenticationProviderFactory {}

// class MockAuthenticationProvider extends Mock
//     implements AuthenticationProvider {}

// class MockAuthCredential extends Mock implements AuthCredential {}

// class MockFirebaseUser extends Mock implements FirebaseUser {}

// void main() {
//   group("user is not logged in", () {
//     MockSharedPreferences prefs = MockSharedPreferences();

//     when(prefs.containsKey('isLoggedIn')).thenReturn(false);

//     LoginState state = LoginState(
//       preferences: prefs,
//       firebaseAuth: MockFirebaseAuth(),
//     );

//     test("initial state is logged out", () {
//       expect(state.isLoggedIn(), false);
//     });

//     test("no user when not logged in", () {
//       expect(state.currentUser(), isNull);
//     });

//     test("no loading", () {
//       expect(state.isLoading(), isFalse);
//     });
//   });

//   group("when login", () {
//     MockSharedPreferences prefs = MockSharedPreferences();
//     MockAuthenticationProviderFactory authFactory =
//         MockAuthenticationProviderFactory();
//     MockAuthenticationProvider authenticationProvider =
//         MockAuthenticationProvider();
//     MockFirebaseAuth auth = MockFirebaseAuth();

//     when(prefs.containsKey('isLoggedIn')).thenReturn(false);
//     when(authFactory.createAuthProvider(LoginProvider.GOOGLE))
//         .thenReturn(authenticationProvider);
//     when(authenticationProvider.handleSignIn()).thenAnswer((_) async => null);

//     LoginState state;

//     setUp(() {
//       state = LoginState(
//         preferences: prefs,
//         firebaseAuth: auth,
//         authenticationProviderFactory: authFactory,
//       );
//     });

//     tearDown(() {
//       state.dispose();
//     });

//     test("should set isLoading to true", () async {
//       expectEvents(state, [
//         () => expect(state.isLoading(), true),
//         () => expect(state.isLoading(), false),
//       ]);

//       await state.login(LoginProvider.GOOGLE);
//     });

//     test("user is logged in if has credentials", () async {
//       var credentials = MockAuthCredential();
//       var user = MockFirebaseUser();
//       when(user.displayName).thenReturn("Test User");

//       when(authenticationProvider.handleSignIn())
//           .thenAnswer((_) async => credentials);
//       when(auth.signInWithCredential(credentials))
//           .thenAnswer((_) async => user);

//       expectEvents(state, [
//         ignoreEvent,
//         () {
//           expect(state.currentUser(), isNotNull);
//           expect(state.isLoggedIn(), true);
//         },
//       ]);

//       await state.login(LoginProvider.GOOGLE);
//     });
//   });
// }

// void ignoreEvent() => null;

// void expectEvents<T extends ChangeNotifier>(
//     T listenable, List<Function> events) {
//   int numCall = 0;
//   listenable.addListener(() {
//     events[numCall++]();
//   });
// }
