import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:como_gasto/states/login_state.dart';
import 'package:como_gasto/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.t('settings.title')),
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
                      child: Text(localizations.t('settings.dark_mode')),
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
                  Provider.of<LoginState>(context).logout();
                  Navigator.of(context).pop();
                },
                child: Text(localizations.t('settings.signout')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
