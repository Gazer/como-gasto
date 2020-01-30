import 'package:flutter/material.dart';

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
