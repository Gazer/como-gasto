import 'package:como_gasto/auth_providers/auth_provider.dart';
import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../states/login_state.dart';
import 'ui/legal_notice_widget.dart';
import 'ui/social_login_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              localizations.t('login.title'),
              style: Theme.of(context).textTheme.display1,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                height: 300,
                child: FlareActor(
                  "assets/login_background.flr",
                  animation: "idle",
                ),
              ),
            ),
            Text(
              localizations.t('login.subtitle'),
              style: Theme.of(context).textTheme.caption,
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child) {
                if (value.isLoading()) {
                  return CircularProgressIndicator();
                } else {
                  return child;
                }
              },
              child: Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SocialLoginWidget(
                      backgroundColor: Color(0xff00aced),
                      iconData: FontAwesomeIcons.twitter,
                    ),
                    FloatingActionButton(
                      backgroundColor: Color(0xff4285F4),
                      child: Icon(FontAwesomeIcons.google),
                      onPressed: () {
                        Provider.of<LoginState>(context, listen: false)
                            .login(LoginProvider.GOOGLE);
                      },
                    ),
                    SocialLoginWidget(
                      backgroundColor: Color(0xff3b5998),
                      iconData: FontAwesomeIcons.facebook,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: LegalNoticeWidget(),
            )
          ],
        ),
      ),
    );
  }
}
