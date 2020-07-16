import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:flutter/material.dart';

class MonthSelectorSlider extends StatefulWidget {
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const MonthSelectorSlider({Key key, this.currentPage, this.onPageChanged})
      : super(key: key);

  @override
  _MonthSelectorSliderState createState() => _MonthSelectorSliderState();
}

class _MonthSelectorSliderState extends State<MonthSelectorSlider> {
  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: widget.currentPage,
      viewportFraction: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations =
        Localizations.of<ComoGastoLocalizations>(
            context, ComoGastoLocalizations);

    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: widget.onPageChanged,
        controller: _controller,
        children: <Widget>[
          _pageItem(localizations.t("months.jan"), 0),
          _pageItem(localizations.t("months.feb"), 1),
          _pageItem(localizations.t("months.mar"), 2),
          _pageItem(localizations.t("months.apr"), 3),
          _pageItem(localizations.t("months.may"), 4),
          _pageItem(localizations.t("months.jun"), 5),
          _pageItem(localizations.t("months.jul"), 6),
          _pageItem(localizations.t("months.aug"), 7),
          _pageItem(localizations.t("months.sep"), 8),
          _pageItem(localizations.t("months.oct"), 9),
          _pageItem(localizations.t("months.nov"), 10),
          _pageItem(localizations.t("months.dec"), 11),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == widget.currentPage) {
      _alignment = Alignment.center;
    } else if (position > widget.currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == widget.currentPage ? selected : unselected,
      ),
    );
  }
}
