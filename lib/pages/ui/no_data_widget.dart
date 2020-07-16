import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations =
        Localizations.of<ComoGastoLocalizations>(
            context, ComoGastoLocalizations);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/no_data.png'),
          SizedBox(height: 80),
          Text(
            localizations.t('home.emptyList'),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}
