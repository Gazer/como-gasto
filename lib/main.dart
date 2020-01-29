import 'package:como_gasto/others/add_page_transition.dart';
import 'package:como_gasto/pages/settings_page.dart';
import 'package:como_gasto/states/login_state.dart';
import 'package:como_gasto/pages/add_page.dart';
import 'package:como_gasto/pages/details_page_container.dart';
import 'package:como_gasto/pages/home_page.dart';
import 'package:como_gasto/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'como_gasto_localizations.dart';
import 'expenses_repository.dart';
import 'states/theme_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(
          builder: (_) => ThemeState(),
        ),
        ChangeNotifierProvider<LoginState>(
          builder: (BuildContext context) => LoginState(),
        ),
        ProxyProvider<LoginState, ExpensesRepository>(
          builder: (_, LoginState value, __) {
            if (value.isLoggedIn()) {
              return ExpensesRepository(value
                  .currentUser()
                  .uid);
            }
            return null;
          },
        )
      ],
      child: Consumer<ThemeState>(
        builder: (context, state, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: state.currentTheme,
            onGenerateRoute: (settings) {
              if (settings.name == '/details') {
                DetailsParams params = settings.arguments;
                return MaterialPageRoute(builder: (BuildContext context) {
                  return DetailsPageContainer(
                    params: params,
                  );
                });
              } else if (settings.name == '/add') {
                Rect buttonRect = settings.arguments;

                return AddPageTransition(
                  page: AddPage(
                    buttonRect: buttonRect,
                  ),
                );
              } else if (settings.name == '/settings') {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return SettingsPage();
                });
              }
              return null;
            },
            routes: {
              '/': (BuildContext context) {
                var state = Provider.of<LoginState>(context);
                if (state.isLoggedIn()) {
                  return HomePage();
                } else {
                  return LoginPage();
                }
              },
            },
            supportedLocales: [
              Locale('en'),
              Locale('es'),
            ],
            localizationsDelegates: [
              ComoGastoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
