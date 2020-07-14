import 'package:como_gasto/others/add_page_transition.dart';
import 'package:como_gasto/pages/settings_page.dart';
import 'package:como_gasto/states/login_state.dart';
import 'package:como_gasto/pages/add_page.dart';
import 'package:como_gasto/pages/details_page_container.dart';
import 'package:como_gasto/pages/home_page.dart';
import 'package:como_gasto/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'como_gasto_localizations.dart';
import 'expenses_repository.dart';
import 'states/theme_state.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(
          create: (_) => ThemeState(),
        ),
        ChangeNotifierProvider<LoginState>(
          create: (BuildContext context) => GetIt.instance(),
        ),
        ProxyProvider<LoginState, ExpensesRepository>(
          update: (_, LoginState value, __) {
            if (value.isLoggedIn()) {
              return ExpensesRepository(value.currentUser().uid);
            }
            return null;
          },
        )
      ],
      child: Consumer<ThemeState>(
        builder: (context, state, child) {
          return Consumer<LoginState>(
              builder: (context, loginProvider, child1) {
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
                  if (loginProvider.isLoggedIn()) {
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
          });
        },
      ),
    );
  }
}
