import 'package:como_gasto/add_page_transition.dart';
import 'package:como_gasto/login_state.dart';
import 'package:como_gasto/pages/add_page.dart';
import 'package:como_gasto/pages/details_page.dart';
import 'package:como_gasto/pages/home_page.dart';
import 'package:como_gasto/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      builder: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsPage(
                  params: params ,
                );
              }
            );
          }
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


