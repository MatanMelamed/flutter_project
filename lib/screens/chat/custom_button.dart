import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final EdgeInsets padding;
  final Color color;


  CustomButton(
      {Key key,
      @required this.callback,
      @required this.text,
      this.padding,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding ?? EdgeInsets.all(8.0),
      child: Material(
        color: this.color ?? Colors.blueGrey,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.callback,
          minWidth: 200.0,
          height: 45.0,
          child: Text(this.text),
        ),
      ),
    );
  }
}
