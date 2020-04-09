import 'package:flutter/material.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),//check!!
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration( //OPTIONAL
                      shape: BoxShape.circle,
//                      image: DecorationImage(image: new Image))
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
