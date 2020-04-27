import 'package:flutter/material.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

class Tests extends StatefulWidget {
  @override
  _TestsState createState() => _TestsState();
}

class _TestsState extends State<Tests> {


  @override
  Widget build(BuildContext context) {
    AuthService s = AuthService();

    return SafeArea(
      child: Container(
        color: Colors.white70,
        child: Column(
          children: <Widget>[
            Text('H'),
            FlatButton(
              child: Text('sign in'),
              onPressed: () {
                s.signInWithEmailAndPassword('matan.mel@gmail.com', '12345678');
              },
              ),
            FlatButton(
              child: Text('log out'),
              onPressed: () {
                s.signOut();
              },
              )
          ],
          ),
        ),
      );
  }
}
