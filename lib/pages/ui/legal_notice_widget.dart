import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:como_gasto/hooks/tap_gesture_recognizer_hook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LegalNoticeWidget extends HookWidget {
  const LegalNoticeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldFont =
        Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold);
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);
    final _recognizer1 = useTapGestureRecognizer(() =>
        showHelp(context, _getTranslatedString(context, 'login.help.terms')));
    final _recognizer2 = useTapGestureRecognizer(() =>
        showHelp(context, _getTranslatedString(context, 'login.help.privacy')));

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

  String _getTranslatedString(BuildContext context, String key) {
    return ComoGastoLocalizations.of(context).t(key);
  }

  void showHelp(BuildContext context, String s) {
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
