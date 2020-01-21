import 'package:como_gasto/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Consumer<ThemeState>(
              builder: (context, state, child) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Text("Use Dark mode?"),
                    ),
                    Switch(
                      value: state.isDarkModeEnabled,
                      onChanged: (_) {
                        state.setDarkMode(!state.isDarkModeEnabled);
                      },
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  //Provider.of<LoginState>(context).logout();
                },
                child: Text("Sign Out"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
