import 'package:flutter/material.dart';


class CustomFlatButton extends StatelessWidget {

  CustomFlatButton({required this.text, required this.callback});

  final String text;
  final GestureTapCallback callback;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      minimumSize: Size(24, 24),
      padding: EdgeInsets.all(0),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: callback,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}