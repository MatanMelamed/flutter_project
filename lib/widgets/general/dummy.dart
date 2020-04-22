import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';

class DummyNavigateOnClick extends StatelessWidget {
  final Widget w;

  DummyNavigateOnClick({this.w});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: RaisedButton(
              onPressed: (){
                Navigator.push(context, createRoute(w));
              },
              child: SvgPicture.asset("assets/images/touch.svg"),
            ),
          ),
        ),
      ),
    );
  }
}
