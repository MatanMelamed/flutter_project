import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget GetNarrowReturnBar(BuildContext context){
  return Container(
    height: 30,
    width: double.infinity,
    child: Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
              )),
        ),
      ),
    decoration: BoxDecoration(boxShadow: <BoxShadow>[
      BoxShadow(color: Colors.black54, blurRadius: 10.0, offset: Offset(0.0, 0.75))
    ], color: Colors.blue),
    );
}