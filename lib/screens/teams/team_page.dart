import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';

class TeamPage extends StatelessWidget {

  Team team;

  TeamPage({this.team});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Text("f"),
              Image(image: team.image.image)
            ],
          ),
        ),
      ),
    );
  }


}
