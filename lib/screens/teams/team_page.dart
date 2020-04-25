import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/screens/teams/team_options.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';
import 'package:teamapp/widgets/general/narrow_returnbar.dart';

class TeamPage extends StatefulWidget {
  Team team;

  TeamPage({this.team});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with TickerProviderStateMixin {
  File previewImage;

  Widget GetPreviewImage() {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height - top,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GetNarrowReturnBar(context),
//              Container(
//                height: 30,
//                width: double.infinity,
//                child: Align(
//                  alignment: Alignment.centerLeft,
//                  child: SizedBox(
//                    child: IconButton(
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        icon: Icon(
//                          Icons.arrow_back_ios,
//                          size: 16,
//                        )),
//                  ),
//                ),
//                decoration: BoxDecoration(boxShadow: <BoxShadow>[
//                  BoxShadow(color: Colors.black54, blurRadius: 10.0, offset: Offset(0.0, 0.75))
//                ], color: Colors.blue),
//              ),
              SizedBox(height: 30),
              Container(
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10),
                    DiamondImage(),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        print('team options clicked');
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => TeamOptionsPage(team: widget.team)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 13),
                        child: SvgPicture.asset(
                          "assets/icons/options-halved.svg",
                        ),
                      ),
                    ),
                    SizedBox(width: 17),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 5),
                            child: Text(
                              widget.team.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 85,
                            padding: const EdgeInsets.only(top: 10, left: 0, right: 3),
                            child: Text(
                              widget.team.description,
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 3),
                          color: Colors.blue[400],
                        ),
                        //color: Colors.blue[400],
                        child: TabBar(
                          indicator: BoxDecoration(
                            //color: Colors.transparent,
                            color: Colors.white38,
                            //border: Border.all(color: Colors.black87, width: 2),
                          ),
                          indicatorColor: Colors.orange,
                          tabs: <Widget>[
                            Tab(child: Text('Meetups', style: TextStyle(fontSize: 18))),
                            Tab(child: Text('Messages', style: TextStyle(fontSize: 18))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Container(
                              height: 200,
                              color: Colors.lightBlueAccent[100],
                            ),
                            Container(
                              height: 200,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
