import 'package:como_gasto/add_page_transition.dart';
import 'package:como_gasto/login_state.dart';
import 'package:como_gasto/pages/add_page.dart';
import 'package:como_gasto/pages/details_page_container.dart';
import 'package:como_gasto/pages/home_page.dart';
import 'package:como_gasto/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenses_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
      ),
    );
  }
}
