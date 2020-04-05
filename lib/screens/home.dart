import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Home")),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _authService.signOut(); // wait until completion
            },
            icon: Icon(Icons.person),
            label: Text("logout"),
          )
        ],
      ),
    );
  }
}
