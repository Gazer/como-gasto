import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Provider<String>.value(
        value: 'Hello World',
        child: Consumer<String>(
          builder: (context, value, child) => Text(value),
      ),
    );
  }
}
