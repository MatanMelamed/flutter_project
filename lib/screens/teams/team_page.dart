import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';

class TeamPage extends StatefulWidget {
  Team team;

  TeamPage({this.team});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
          ),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.team.image),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Colors.red, width: 4),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(widget.team.name),

                    //_team_image ?? Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
