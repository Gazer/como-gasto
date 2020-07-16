import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:como_gasto/como_gasto_icons.dart';
import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:como_gasto/others/month_widget.dart';
import 'package:como_gasto/pages/notifications/local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';

import '../expenses_repository.dart';
import '../utils.dart';
import 'ui/loading_widget.dart';
import 'ui/month_selector_slider.dart';
import 'ui/no_data_widget.dart';
import 'ui/stream_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var globalKey = RectGetter.createGlobalKey();
  Rect buttonRect;

  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

  @override
  void initState() {
    super.initState();

    setupNotificationPlugin();
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesRepository>(
        builder: (BuildContext context, ExpensesRepository db, Widget child) {
      _query = db.queryByMonth(currentPage + 1);

      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomAction(ComoGastoIcons.stats_bars, () {
                setState(() {
                  currentType = GraphType.LINES;
                });
              }),
              _bottomAction(ComoGastoIcons.pie_chart, () {
                setState(() {
                  currentType = GraphType.PIE;
                });
              }),
              SizedBox(width: 48.0),
              _bottomAction(ComoGastoIcons.cart, () {}),
              _bottomAction(ComoGastoIcons.settings, () {
                Navigator.pushNamed(context, '/settings');
              }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: RectGetter(
          key: globalKey,
          child: FloatingActionButton(
            child: Icon(ComoGastoIcons.plus),
            onPressed: () {
              buttonRect = RectGetter.getRectFromKey(globalKey);

              Navigator.of(context).pushNamed('/add', arguments: buttonRect);
            },
          ),
        ),
        body: _body(),
      );
    });
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          MonthSelectorSlider(
            currentPage: currentPage,
            onPageChanged: (newPage) {
              var db = Provider.of<ExpensesRepository>(context, listen: false);

              setState(() {
                currentPage = newPage;
                _query = db.queryByMonth(currentPage + 1);
              });
            },
          ),
          StreamWidget(
            stream: _query,
            loading: (_) => LoadingWidget(),
            empty: (_) => NoDataWidget(),
            done: (_, data) => MonthWidget(
              days: daysInMonth(currentPage + 1),
              documents: data.documents,
              graphType: currentType,
              month: currentPage,
            ),
          ),
        ],
      ),
    );
  }

  void setupNotificationPlugin() {
    LocalNotifications localNotifications = GetIt.I();

    localNotifications.init(
      onSelectNotification: onSelectNotification,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("Don't forget to add your expenses"),
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
