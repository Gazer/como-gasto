import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TapGestureRecognizer useTapGestureRecognizer(Function onTap) {
  return Hook.use(_TapGestureRecognizerHook(onTap));
}

class _TapGestureRecognizerHook extends Hook<TapGestureRecognizer> {
  final Function onTap;

  _TapGestureRecognizerHook(this.onTap);

  @override
  _TapGestureRecognizerHookState createState() =>
      _TapGestureRecognizerHookState();
}

class _TapGestureRecognizerHookState
    extends HookState<TapGestureRecognizer, _TapGestureRecognizerHook> {
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initHook() {
    super.initHook();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = hook.onTap;
  }


  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  TapGestureRecognizer build(BuildContext context) {
    return _tapGestureRecognizer;
  }
}
