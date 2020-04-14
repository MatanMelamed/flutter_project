import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/screens/profile/profile_page.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

class Home extends StatelessWidget {
  final String uid ;

  Home({this.uid});

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
            icon: Icon(Icons.exit_to_app),
            label: Text("logout"),
          ),
          FlatButton.icon(
            onPressed: () async {
              Navigator.of(context).push(createRoute(ProfilePage(uid: uid))); // wait until completion
            },
            icon: Icon(Icons.person),
            label: Text("profile"),
          )

        ],
      ),
    );
  }
}
