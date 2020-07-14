import 'dart:io';

import 'package:como_gasto/como_gasto_localizations.dart';
import 'package:como_gasto/others/category_selection_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yaml/yaml.dart';
import 'dart:io' show Platform;

import '../como_gasto_icons.dart';
import '../expenses_repository.dart';

class AddPage extends StatefulWidget {
  final Rect buttonRect;

  const AddPage({Key key, this.buttonRect}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _buttonAnimation;
  Animation _pageAnimation;

  String category;
  int value = 0;

  String dateStr;
  DateTime date = DateTime.now();

  File _selectedPicture;

  LocalAuthentication _localAth;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _localAth = LocalAuthentication();
      _localAth.canCheckBiometrics.then((b) async {
        var methods = await _localAth.getAvailableBiometrics();
        var hasFingerprint = Platform.isIOS
            ? methods.any((m) => m == BiometricType.fingerprint)
            : true;

        setState(() {
          _isBiometricAvailable = b && hasFingerprint;
        });
      });
    }

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _pageAnimation = Tween<double>(begin: -1, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        Navigator.of(context).pop();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    ComoGastoLocalizations localizations = ComoGastoLocalizations.of(context);
    if (dateStr == null) {
      dateStr = localizations.t('add.today');
    }

    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, h * (1 - _pageAnimation.value)),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: BackButtonIcon(),
                color: Colors.grey,
                onPressed: () {
                  _controller.reverse();
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                "${localizations.t('add.category')} ($dateStr)",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              centerTitle: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(ComoGastoIcons.calendar),
                  color: Colors.grey,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(Duration(hours: 24 * 30)),
                      lastDate: DateTime.now(),
                    ).then((newDate) {
                      if (newDate != null) {
                        setState(() {
                          date = newDate;
                          dateStr =
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        });
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(ComoGastoIcons.camera),
                  color: Colors.grey,
                  onPressed: () async {
                    var image =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    setState(() {
                      _selectedPicture = image;
                    });
                  },
                )
              ],
            ),
            body: _body(localizations),
          ),
        ),
        _submit(localizations),
      ],
    );
  }

  Widget _body(ComoGastoLocalizations localizations) {
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        _categorySelector(localizations),
        if (_selectedPicture != null)
          SizedBox(
            height: 100,
            child: Image.file(_selectedPicture),
          ),
        _currentValue(localizations),
        _numpad(),
        SizedBox(
          height: h - widget.buttonRect.top,
        )
      ],
    );
  }

  Widget _categorySelector(ComoGastoLocalizations localizations) {
    YamlList categories = localizations.t('add.categories');
    print(categories);

    return Container(
      height: 80.0,
      child: CategorySelectionWidget(
        categories: {
          categories[0]: Icons.shopping_cart,
          categories[1]: FontAwesomeIcons.beer,
          categories[2]: FontAwesomeIcons.hamburger,
          categories[3]: FontAwesomeIcons.wallet,
          categories[4]: FontAwesomeIcons.carAlt,
          categories[5]: FontAwesomeIcons.infinity,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue(ComoGastoLocalizations localizations) {
    var realValue = value / 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        "${localizations.t('add.currency')}${realValue.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Theme.of(context).textTheme.title.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ",") {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;

        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              _num(",", height),
              _num("0", height),
              GestureDetector(
                onTap: () {
                  setState(() {
                    value = value ~/ 10;
                  });
                },
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.backspace,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ],
        );
      }),
    );
  }

  Widget _submit(ComoGastoLocalizations localizations) {
    if (_controller.value < 1) {
      var buttonWidth = widget.buttonRect.right - widget.buttonRect.left;
      var w = MediaQuery.of(context).size.width;

      return Positioned(
        left: widget.buttonRect.left * (1 - _buttonAnimation.value),
        //<-- Margin from left
        right: (w - widget.buttonRect.right) * (1 - _buttonAnimation.value),
        //<-- Margin from right
        top: widget.buttonRect.top,
        //<-- Margin from top
        bottom:
            (MediaQuery.of(context).size.height - widget.buttonRect.bottom) *
                (1 - _buttonAnimation.value),
        //<-- Margin from bottom
        child: Container(
          width: double.infinity,
          //<-- Blue cirle
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                buttonWidth * (1 - _buttonAnimation.value)),
            color:
                Theme.of(context).floatingActionButtonTheme.backgroundColor ??
                    Theme.of(context).primaryColor,
          ),
          child: MaterialButton(
            onPressed: () {},
            child: Text(
              localizations.t("add.add"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: widget.buttonRect.top,
        bottom: 0,
        left: 0,
        right: 0,
        child: Builder(builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor ??
                    Theme.of(context).primaryColor),
            child: MaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    localizations.t("add.add"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  if (_isBiometricAvailable)
                    Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 30.0,
                    )
                ],
              ),
              onPressed: () async {
                var db =
                    Provider.of<ExpensesRepository>(context, listen: false);
                if (value > 0 && category != "") {
                  if (_isBiometricAvailable) {
                    bool didAuthenticate =
                        await _localAth.authenticateWithBiometrics(
                      localizedReason: "Please identify yourself!",
                    );
                    if (didAuthenticate) {
                      _saveAndBack(db);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text("You need to identify yourself."),
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
                  } else {
                    _saveAndBack(db);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(
                                "You need to select a category and a value greater than zero."),
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
              },
            ),
          );
        }),
      );
    }
  }

  _saveAndBack(ExpensesRepository db) {
    db.add(category, value / 100.0, date, _selectedPicture);

    _controller.reverse();
  }
}
