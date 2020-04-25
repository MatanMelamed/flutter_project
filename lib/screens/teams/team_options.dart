import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';
import 'package:teamapp/widgets/general/narrow_returnbar.dart';

class TeamOptionsPage extends StatefulWidget {

  Team team;

  TeamOptionsPage({this.team});

  @override
  _TeamOptionsPageState createState() => _TeamOptionsPageState();
}

class _TeamOptionsPageState extends State<TeamOptionsPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            GetNarrowReturnBar(context),
            SizedBox(height: 30),
            DiamondImage(size: 150),

            

          ],
        ),
      ),
    );
  }
}
