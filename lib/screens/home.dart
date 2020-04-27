import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.black45,
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
      body: MainUserProfilePage(
        user: user
      ),
    );
  }
}
