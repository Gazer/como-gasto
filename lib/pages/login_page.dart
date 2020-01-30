import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../states/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TapGestureRecognizer _recognizer1;
  TapGestureRecognizer _recognizer2;

  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
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
            Expanded(
              flex: 1,
              child: Container(),
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
                        Provider.of<LoginState>(context)
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
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    text: localizations.t('login.notice.line1'),
                    children: [
                      TextSpan(
                        text: localizations.t('login.notice.line2'),
                        recognizer: _recognizer1,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: localizations.t('login.notice.line3')),
                      TextSpan(
                        text: localizations.t('login.notice.line4'),
                        recognizer: _recognizer2,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _recognizer1 = TapGestureRecognizer()
      ..onTap = () {
        showHelp(_getTranslatedString('login.help.terms'));
      };
    _recognizer2 = TapGestureRecognizer()
      ..onTap = () {
        showHelp(_getTranslatedString('login.help.privacy'));
      };
  }

  @override
  void dispose() {
    super.dispose();
    _recognizer1.dispose();
    _recognizer2.dispose();
  }

  String _getTranslatedString(String key) {
    return ComoGastoLocalizations.of(context).t(key);
  }

  void showHelp(String s) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(s),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}

class SocialLoginWidget extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;

  const SocialLoginWidget({
    Key key,
    @required this.backgroundColor,
    @required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.grey,
      child: Icon(
        iconData,
        color: Colors.white,
      ),
      onPressed: () {
        // Provider.of<LoginState>(context).login(LoginProvider.FACEBOOK);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Comming soon"),
        ));
      },
    );
  }
}
