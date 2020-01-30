import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LegalNoticeWidget extends StatefulWidget {
  const LegalNoticeWidget({
    Key key,
  }) : super(key: key);

  @override
  _LegalNoticeWidgetState createState() => _LegalNoticeWidgetState();
}

class _LegalNoticeWidgetState extends State<LegalNoticeWidget> {
  TapGestureRecognizer _recognizer1;
  TapGestureRecognizer _recognizer2;

  @override
  Widget build(BuildContext context) {
    final boldFont =
        Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold);
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        text: localizations.t('login.notice.line1'),
        children: [
          TextSpan(
            text: localizations.t('login.notice.line2'),
            recognizer: _recognizer1,
            style: boldFont,
          ),
          TextSpan(text: localizations.t('login.notice.line3')),
          TextSpan(
            text: localizations.t('login.notice.line4'),
            recognizer: _recognizer2,
            style: boldFont,
          ),
        ],
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
      ),
    );
  }
}
