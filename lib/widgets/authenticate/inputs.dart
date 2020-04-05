import 'package:flutter/material.dart';
import 'package:teamapp/theme/white.dart';

InputDecoration GetInputDecor(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: kLabelStyle,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(7),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(7),
    ),
  );
}

Future GetErrorDialog(BuildContext context, String errorTitle,String errorMessage) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorTitle),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('leave'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
